using Godot;
using System;
using System.IO.Ports;

public partial class Node2d : Node2D
{
	// Definir el objeto SerialPort
	SerialPort serialPort;
	
	// Definir un RichTextLabel para mostrar los datos recibidos
	RichTextLabel text;
	
	// Variable para almacenar la información leída del puerto serial
	string serialData = "";

	// Se llama cuando el nodo entra en la escena por primera vez
	public override void _Ready()
	{
		// Inicializar el RichTextLabel
		text = GetNode<RichTextLabel>("RichTextLabel");
		
		// Inicializar y configurar el puerto serial
		serialPort = new SerialPort();
		serialPort.PortName = "COM5";  // Ajusta el nombre del puerto según tu configuración
		serialPort.BaudRate = 9600;    // Velocidad de comunicación
		serialPort.ReadTimeout = 500;  // Tiempo de espera para leer el puerto
		
		try
		{
			// Abrir el puerto serial
			serialPort.Open();
			GD.Print("Puerto serial abierto correctamente");
		}
		catch (Exception e)
		{
			GD.PrintErr("Error al abrir el puerto serial: ", e.Message);
		}
	}

	// Se llama cada frame, 'delta' es el tiempo transcurrido desde el frame anterior
	public override void _Process(double delta)
	{
		// Verificar si el puerto serial está abierto y hay datos disponibles
		if (serialPort.IsOpen && serialPort.BytesToRead > 0)
		{
			try
			{
				// Leer los datos desde el puerto serial
				serialData = serialPort.ReadLine();
				
				// Actualizar el texto en el RichTextLabel
				text.Text = $"Valor recibido: {serialData}";
				
				// Imprimir los datos en la consola para depuración
				GD.Print("Datos recibidos: ", serialData);
			}
			catch (TimeoutException)
			{
				GD.Print("Tiempo de espera agotado para leer datos");
			}
		}
	}

	// Se llama cuando el nodo sale de la escena, para cerrar el puerto serial
	public override void _ExitTree()
	{
		// Verificar si el puerto serial está abierto y cerrarlo
		if (serialPort.IsOpen)
		{
			serialPort.Close();
			GD.Print("Puerto serial cerrado");
		}
	}
}
