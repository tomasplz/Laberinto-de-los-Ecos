//Modificar funcion de deteccion del arduino, detectar el puerto automaticamente
// y empezar a ocuparlo asi

using System;
using System.IO.Ports;
using System.Text.RegularExpressions;
using Godot;

public partial class Arduino : Node2D
{
	private SerialPort serialPort;   // Objeto para manejar el puerto serial
	private RichTextLabel text;      // Referencia al componente de texto en la UI
	private double elapsedTime = 0;  // Controla la frecuencia de lectura
	private string textoAcumulado = "";  // Texto acumulado que se concatena hasta que se presiona Enter

	// Definimos varios mapas para diferentes modos del teclado
	private string[,] valoresNumericos = {
		{"1", "2", "3", ","},   // Primera fila: números y ","
		{"4", "5", "6", "00"},  // Segunda fila: números y "00"
		{"7", "8", "9", "0"},   // Tercera fila: números y "0"
		{"<-", " ", "ENTER", "->"}  // Última fila dedicada a funciones especiales
	};

	private char[,] valoresLetras = {
		{'A', 'B', 'C', 'D'},
		{'E', 'F', 'G', 'H'},
		{'I', 'J', 'K', 'L'},
		{' ', ' ', ' ', ' '} // Última fila dedicada a funciones especiales
	};

	private char[,] valoresSimbolos = {
		{'!', '@', '#', '$'},
		{'%', '^', '&', '*'},
		{'(', ')', '-', '+'},
		{' ', ' ', ' ', ' '} // Última fila dedicada a funciones especiales
	};

	private string[,] valoresChinos = {
		{"一", "二", "三", "四"},  // 1, 2, 3, 4 en chino
		{"五", "六", "七", "八"},  // 5, 6, 7, 8 en chino
		{"九", "十", "百", "千"},  // 9, 10, 100, 1000 en chino
		{" ", " ", " ", " "}     // Última fila dedicada a funciones especiales
	};

	// Enumeración para definir los diferentes modos del teclado
	private enum ModoTeclado
	{
		Numerico,
		Letras,
		Simbolos,
		Chino
	}

	private ModoTeclado modoActual = ModoTeclado.Numerico;  // Modo inicial del teclado

	public override void _Ready()
	{
		// Obtener referencia al RichTextLabel en la escena
		text = GetNode<RichTextLabel>("RichTextLabel");

		try
		{
			// Ajusta el nombre del puerto según tu sistema ("/dev/ttyUSB0" para Linux)
			serialPort = new SerialPort("/dev/ttyUSB0", 9600);
			serialPort.Open();
			GD.Print("Puerto abierto exitosamente.");
		}
		catch (Exception ex)
		{
			GD.PrintErr($"No se pudo abrir el puerto: {ex.Message}");
		}
	}

	public override void _Process(double delta)
	{
		// Lee del puerto cada 100 ms
		elapsedTime += delta;
		if (elapsedTime < 0.1) return;
		elapsedTime = 0;

		if (serialPort != null && serialPort.IsOpen)
		{
			try
			{
				if (serialPort.BytesToRead > 0)
				{
					// Lee una línea completa del puerto serial
					string serialMessage = serialPort.ReadLine().Trim();

					// Verifica si el mensaje no está vacío y tiene el formato esperado
					if (!string.IsNullOrEmpty(serialMessage))
					{
						GD.Print($"Mensaje recibido: {serialMessage}");

						// Extraer las coordenadas del formato (fila,columna)
						var match = Regex.Match(serialMessage, @"\((\d+),(\d+)\)");
						if (match.Success)
						{
							int fila = int.Parse(match.Groups[1].Value);
							int columna = int.Parse(match.Groups[2].Value);

							// Verificar si se presiona un botón especial de la última fila
							if (fila == 3 && columna == 0)
							{
								CambiarModoAnterior();
							}
							else if (fila == 3 && columna == 3)
							{
								CambiarModoSiguiente();
							}
							else if (fila == 3 && columna == 1)  // Botón de Espacio
							{
								textoAcumulado += " ";
								text.Text = $"Texto acumulado: {textoAcumulado}";
							}
							else if (fila == 3 && columna == 2)  // Botón de Enter
							{
								GD.Print($"Texto final: {textoAcumulado}");
								textoAcumulado = "";  // Borrar el texto acumulado
								text.Text = "Texto enviado. Acumulado borrado.";
							}
							else
							{
								// Obtener el valor basado en el modo actual y concatenar al texto acumulado
								string valorTecla = ObtenerValorTecla(modoActual, fila, columna);
								textoAcumulado += valorTecla;
								text.Text = $"Texto acumulado: {textoAcumulado}";
							}
						}
					}
				}
			}
			catch (Exception ex)
			{
				GD.PrintErr($"Error leyendo del puerto: {ex.Message}");
				serialPort.DiscardInBuffer();  // Limpia el buffer en caso de error para evitar lecturas corruptas
			}
		}
	}

	// Método para cambiar al modo siguiente del teclado
	private void CambiarModoSiguiente()
	{
		if (modoActual == ModoTeclado.Numerico)
		{
			modoActual = ModoTeclado.Letras;
			text.Text = "Modo cambiado: Letras";
		}
		else if (modoActual == ModoTeclado.Letras)
		{
			modoActual = ModoTeclado.Simbolos;
			text.Text = "Modo cambiado: Símbolos";
		}
		else if (modoActual == ModoTeclado.Simbolos)
		{
			modoActual = ModoTeclado.Chino;
			text.Text = "Modo cambiado: Chino";
		}
		else if (modoActual == ModoTeclado.Chino)
		{
			modoActual = ModoTeclado.Numerico;
			text.Text = "Modo cambiado: Numérico";
		}
	}

	// Método para cambiar al modo anterior del teclado
	private void CambiarModoAnterior()
	{
		if (modoActual == ModoTeclado.Numerico)
		{
			modoActual = ModoTeclado.Chino;
			text.Text = "Modo cambiado: Chino";
		}
		else if (modoActual == ModoTeclado.Chino)
		{
			modoActual = ModoTeclado.Simbolos;
			text.Text = "Modo cambiado: Símbolos";
		}
		else if (modoActual == ModoTeclado.Simbolos)
		{
			modoActual = ModoTeclado.Letras;
			text.Text = "Modo cambiado: Letras";
		}
		else if (modoActual == ModoTeclado.Letras)
		{
			modoActual = ModoTeclado.Numerico;
			text.Text = "Modo cambiado: Numérico";
		}
	}

	// Método para obtener el valor de la tecla basado en el modo actual
	private string ObtenerValorTecla(ModoTeclado modo, int fila, int columna)
	{
		switch (modo)
		{
			case ModoTeclado.Numerico:
				return valoresNumericos[fila, columna];

			case ModoTeclado.Letras:
				return valoresLetras[fila, columna].ToString();

			case ModoTeclado.Simbolos:
				return valoresSimbolos[fila, columna].ToString();

			case ModoTeclado.Chino:
				return valoresChinos[fila, columna];
		}
		return "";
	}

	public override void _ExitTree()
	{
		// Cierra el puerto serial al salir del nodo
		if (serialPort != null && serialPort.IsOpen)
		{
			serialPort.Close();
			GD.Print("Puerto cerrado.");
		}
	}
}
