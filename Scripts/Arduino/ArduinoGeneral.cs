using Godot;
using System;
using System.IO.Ports;
using System.Threading.Tasks;

public partial class ArduinoGeneral : Node
{
	private SerialPort serialPort;
	private const int BAUD_RATE = 9600;
	private const int READ_TIMEOUT = 1000; // Milisegundos
	private const int WRITE_TIMEOUT = 1000; // Milisegundos
	private bool isSynchronized = false;

	// Instancias de los dispositivos
	private WaterSensor waterSensor;
	private Keypad keypad;
	private const int INTERVALO_VERIFICACION = 1000; // Exactamente 1 segundo
	private DateTime ultimaVerificacion;
	private bool esperandoPong = false;

	public override void _Ready()
	{
		GD.Print("Iniciando conexión con Arduino");

		// Inicializar dispositivos
		waterSensor = new WaterSensor();
		keypad = new Keypad();

		// Iniciar tarea para manejar la conexión
		Task.Run(() => ManejarConexion());
	}

	private bool isRunning = true; // Nueva variable de control

	private void ManejarConexion()
	{
		while (isRunning)
		{
			 try
			{
				if (!isRunning) break; // Verificación adicional
				
				if (serialPort == null || !serialPort.IsOpen)
				{
					EstablecerConexionInicial();
				}

				else if (!isSynchronized)
				{
					SincronizarConArduino();
				}
				else
				{
					DateTime ahora = DateTime.Now;
					
					// Verificar conexión exactamente cada segundo
					if ((ahora - ultimaVerificacion).TotalMilliseconds >= INTERVALO_VERIFICACION)
					{
						if (!VerificarConexion())
						{
							GD.PrintErr("Conexión perdida");
							isSynchronized = false;
							serialPort.Close();
							continue;
						}
						ultimaVerificacion = ahora;
					}
					
					// Si no estamos esperando PONG, leer datos
					if (!esperandoPong)
					{
						LeerDatos();
					}
				}
			}
			catch (Exception ex)
			{
				GD.PrintErr($"Error en ManejarConexion: {ex.Message}");
				
				if (!isRunning) break; // Verificación en catch
				GD.PrintErr($"Error en ManejarConexion: {ex.Message}");

				if (serialPort != null && serialPort.IsOpen)
				{
					serialPort.Close();
				}
				isSynchronized = false;
				System.Threading.Thread.Sleep(200);
			}

			System.Threading.Thread.Sleep(10);
		}
	}

	private void EstablecerConexionInicial()
	{
		string portName = DetectarPuertoArduino();
		if (!string.IsNullOrEmpty(portName))
		{
			try
			{
				serialPort = new SerialPort(portName, BAUD_RATE)
				{
					ReadTimeout = READ_TIMEOUT,
					WriteTimeout = WRITE_TIMEOUT
				};
				serialPort.Open();
				GD.Print($"Puerto abierto: {portName}");
				SincronizarConArduino();
			}
			catch (Exception ex)
			{
				GD.PrintErr($"Error al abrir puerto: {ex.Message}");
				System.Threading.Thread.Sleep(1000);
			}
		}
	}

	private void SincronizarConArduino()
	{
		try
		{
			string response = serialPort.ReadLine().Trim();
			if (response.Equals("SYNCHRONIZE", StringComparison.OrdinalIgnoreCase))
			{
				serialPort.WriteLine("CONFIRM");
				isSynchronized = true;
				ultimaVerificacion = DateTime.Now;
				GD.Print("Arduino sincronizado");
			}
		}
		catch (Exception ex)
		{
			GD.PrintErr($"Error de sincronización: {ex.Message}");
			isSynchronized = false;
			if (serialPort != null && serialPort.IsOpen)
				serialPort.Close();
		}
	}

	private void LeerDatos()
	{
		try
		{
			while (serialPort.BytesToRead > 0)
			{
				string message = serialPort.ReadLine().Trim();
				if (!string.IsNullOrEmpty(message))
				{
					ProcesarMensaje(message);
				}
			}
		}
		catch (TimeoutException) { }
		catch (Exception ex)
		{
			GD.PrintErr($"Error leyendo datos: {ex.Message}");
			isSynchronized = false;
			if (serialPort != null && serialPort.IsOpen)
				serialPort.Close();
		}
	}

	private bool VerificarConexion()
	{
		if (!isSynchronized)
			return false;

		try
		{
			// Limpiar buffer antes de enviar PING
			while (serialPort.BytesToRead > 0)
			{
				string pendingData = serialPort.ReadLine().Trim();
				if (pendingData.StartsWith("W:") || pendingData.StartsWith("K:") || pendingData.StartsWith("P:"))
				{
					ProcesarMensaje(pendingData);
				}
			}

			esperandoPong = true;
			serialPort.WriteLine("PING");
			
			// Esperar PONG con timeout reducido
			DateTime inicio = DateTime.Now;
			while ((DateTime.Now - inicio).TotalMilliseconds < 500) // Timeout de 500ms
			{
				if (serialPort.BytesToRead > 0)
				{
					string response = serialPort.ReadLine().Trim();
					if (response.Equals("PONG", StringComparison.OrdinalIgnoreCase))
					{
						esperandoPong = false;
						return true;
					}
					else if (response.StartsWith("W:") || response.StartsWith("K:"))
					{
						// Guardar mensaje de sensores para procesarlo después
						ProcesarMensaje(response);
						continue;
					}
				}
				System.Threading.Thread.Sleep(10);
			}
			
			esperandoPong = false;
			return false;
		}
		catch
		{
			esperandoPong = false;
			return false;
		}
	}

	//Senal de keypad
	[Signal]
	public delegate void KeypadInputEventHandler(string input);
	private void EmitKeypadSignal(string data)
	{
		EmitSignal(SignalName.KeypadInput, data);
	}


	//Senal de waterSensor
	[Signal]
	public delegate void WaterLevelChangedEventHandler(float level);
	private void EmitWaterLevel(float level)
	{
		EmitSignal(SignalName.WaterLevelChanged, level);
	}

	private void ProcesarMensaje(string message)
	{
		if (string.IsNullOrEmpty(message))
			return;

		//GD.Print($"Mensaje recibido: {message}");

		// Manejo de mensajes de sensores y teclado
		if (message.StartsWith("W:") || message.StartsWith("K:") || message.StartsWith("P:"))
		{
			char prefix = message[0];
			string data = message.Substring(2).Trim(); // Formato "W:datos" o "K:datos"
			
			switch (prefix)
			{
				case 'W':
					waterSensor.ProcesarDatos(data);
					float waterLevel = float.Parse(data);
					CallDeferred(nameof(EmitWaterLevel), waterLevel);
				break;
				case 'K':
					// Usar CallDeferred para emitir la señal desde el hilo principal
					CallDeferred(nameof(EmitKeypadSignal), data);
					break;
				case 'P':
					GD.Print("Datos del potenciometro: " + data);
					break;

				default:
					GD.PrintErr($"Prefijo desconocido: {prefix}. Mensaje completo: {message}");
					break;
			}
		}
		else
		{
			GD.PrintErr($"Mensaje no reconocido: {message}");
		}
	}

	private string DetectarPuertoArduino()
	{
		GD.Print("Buscando puertos.");
		string[] portNames = SerialPort.GetPortNames();
		GD.Print("Puertos encontrados: " + string.Join(", ", portNames));

		foreach (string portName in portNames)
		{
			try
			{
				using (SerialPort tempPort = new SerialPort(portName, BAUD_RATE))
				{

					tempPort.ReadTimeout = READ_TIMEOUT;
					tempPort.WriteTimeout = WRITE_TIMEOUT;

					tempPort.Open();
					tempPort.DiscardInBuffer(); // Limpiar el buffer de entrada
					tempPort.WriteLine("CONFIRM");
					GD.Print($"Enviado 'CONFIRM' a {portName}.");

					// Leer la respuesta
					string response = tempPort.ReadLine().Trim();
					GD.Print("Respuesta del puerto " + portName + ": " + response);

					if (response.Equals("SYNCHRONIZE", StringComparison.OrdinalIgnoreCase))
					{
						GD.Print("Arduino encontrado satisfactoriamente");
						return portName;
					}
				}
			}
			catch
			{
				// Ignorar excepciones y continuar buscando
			}
		}
		return null;
	}

	public void CloseConnection()
	{
		isRunning = false; // Detener el bucle primero
		
		if (serialPort != null)
		{
			try
			{
				if (serialPort.IsOpen)
				{
					serialPort.Close();
				}
				serialPort.Dispose();
				serialPort = null;
			}
			catch (Exception ex)
			{
				GD.PrintErr($"Error al cerrar conexión: {ex.Message}");
			}
		}
		waterSensor = null;
		keypad = null;
		
		GD.Print("Conexión cerrada exitosamente");
	}

	public override void _ExitTree()
	{
		if (serialPort != null && serialPort.IsOpen)
		{
			serialPort.Close();
			GD.Print("Puerto cerrado.");
		}
	}
}
