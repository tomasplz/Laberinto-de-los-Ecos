using Godot;
using System;
using System.Text.RegularExpressions;

public partial class Keypad : ArduinoDevice
{
	[Signal]
	public delegate void DigitEnteredEventHandler(int digit);
	
	[Signal] 
	public delegate void CodeValidatedEventHandler(bool isValid);
	
	private string textoAcumulado = "";

	// Mapas para diferentes modos del teclado
	private string[,] valoresNumericos = {
		{"1", "2", "3", ","},
		{"4", "5", "6", "00"},
		{"7", "8", "9", "0"},
		{"<-", " ", "ENTER", "->"}
	};

	private char[,] valoresLetras = {
		{'A', 'B', 'C', 'D'},
		{'E', 'F', 'G', 'H'},
		{'I', 'J', 'K', 'L'},
		{' ', ' ', ' ', ' '}
	};

	private char[,] valoresSimbolos = {
		{'!', '@', '#', '$'},
		{'%', '^', '&', '*'},
		{'(', ')', '-', '+'},
		{' ', ' ', ' ', ' '}
	};

	private string[,] valoresChinos = {
		{"一", "二", "三", "四"},
		{"五", "六", "七", "八"},
		{"九", "十", "百", "千"},
		{" ", " ", " ", " "}
	};

	// Modos del teclado
	private enum ModoTeclado
	{
		Numerico,
		Letras,
		Simbolos,
		Chino
	}

	private ModoTeclado modoActual = ModoTeclado.Numerico;

	public override void ProcesarDatos(string datos)
	{
		// Suponiendo que los datos vienen en el formato (fila,columna)
		var match = Regex.Match(datos, @"\((\d+),(\d+)\)");
		if (match.Success)
		{
			int fila = int.Parse(match.Groups[1].Value);
			int columna = int.Parse(match.Groups[2].Value);

			if (fila == 3 && columna == 0)
			{
				CambiarModoAnterior();
			}
			else if (fila == 3 && columna == 3)
			{
				CambiarModoSiguiente();
			}
			else if (fila == 3 && columna == 1)  // Espacio
			{
				textoAcumulado += " ";
				GD.Print($"Texto acumulado: {textoAcumulado}");
			}
			else if (fila == 3 && columna == 2)  // Enter
			{
				GD.Print($"Texto final: {textoAcumulado}");
				textoAcumulado = "";
			}
			else
			{
				string valorTecla = ObtenerValorTecla(modoActual, fila, columna);
				textoAcumulado += valorTecla;
				GD.Print($"Texto acumulado: {textoAcumulado}");
			}
		}
		else
		{
			GD.PrintErr($"Formato de datos inválido: {datos}");
		}
	}

	private void CambiarModoSiguiente()
	{
		modoActual = (ModoTeclado)(((int)modoActual + 1) % Enum.GetNames(typeof(ModoTeclado)).Length);
		GD.Print($"Modo cambiado a: {modoActual}");
	}

	private void CambiarModoAnterior()
	{
		int totalModos = Enum.GetNames(typeof(ModoTeclado)).Length;
		modoActual = (ModoTeclado)(((int)modoActual - 1 + totalModos) % totalModos);
		GD.Print($"Modo cambiado a: {modoActual}");
	}

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

			default:
				return "";
		}
	}
}
