using Godot;

public partial class WaterSensor : ArduinoDevice
{
	public override void ProcesarDatos(string datos)
	{
		// Lógica para procesar los datos del sensor de agua
		if(int.TryParse(datos, out int nivelAgua))
		{
			GD.Print("Nivel de agua: " + nivelAgua);
			// Realizar acciones según el nivel de agua
		}
		else
		{
			GD.PrintErr("Datos inválidos para el sensor de agua: " + datos);
		}
	}
}
