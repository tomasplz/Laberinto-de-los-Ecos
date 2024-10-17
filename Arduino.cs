using Godot;
using System;
using System.IO.Ports;
using System.IO;

public partial class Arduino : Node2D
{
	private SerialPort serialPort;
	private RichTextLabel text;

	public override void _Ready()
	{
		text = GetNode<RichTextLabel>("RichTextLabel");
		serialPort = new SerialPort();
		serialPort.PortName = "/dev/ttyUSB0";  // Asegúrate de que este sea el puerto correcto
		serialPort.BaudRate = 9600;
		serialPort.Open();
	}

	public override void _Process(double delta)
	{
		if (!serialPort.IsOpen) return;

		try
		{
			string serialMessage = serialPort.ReadExisting();
			if (serialMessage.Contains("BUTTON_PRESSED"))
			{
				text.Text = "El pin está siendo presionado.";
			}
			else if (serialMessage.Contains("BUTTON_NOT_PRESSED"))
			{
				text.Text = "El pin no está presionado.";
			}
		}
		catch (IOException)
		{
			GD.Print("Error leyendo del puerto.");
		}
	}

	public override void _ExitTree()
	{
		if (serialPort.IsOpen)
		{
			serialPort.Close();
		}
	}
}
