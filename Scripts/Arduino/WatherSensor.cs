using Godot;

public partial class WaterSensor : Node
{
    [Signal]
    public delegate void WaterLevelChangedEventHandler(int level);

    public void ProcesarDatos(string data)
    {
        if (int.TryParse(data, out int waterLevel))
        {
            EmitSignal(SignalName.WaterLevelChanged, waterLevel);
        }
    }
}