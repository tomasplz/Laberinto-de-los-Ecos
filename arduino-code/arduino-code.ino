//Its for arduino mega 2560 code

#include <Keypad.h>

// Configuración del teclado 4x4
const byte FILAS = 4;    
const byte COLUMNAS = 4; 
byte pinesFilas[FILAS] = {2, 3, 4, 5};        
byte pinesColumnas[COLUMNAS] = {6, 7, 8, 9};  
char teclas[FILAS][COLUMNAS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};
Keypad keypad = Keypad(makeKeymap(teclas), pinesFilas, pinesColumnas, FILAS, COLUMNAS);

const int sensorAguaPin = A0;
const unsigned long TIMEOUT = 1000;
const unsigned long INTERVALO_PING = 1000; // Intervalo de 1 segundo para PING
unsigned long ultimoPing = 0;
bool sincronizado = false;

const int potenciometroPin = A3;


void setup() {
  Serial.begin(9600);
      pinMode(potenciometroPin, INPUT);
}

void loop() {
  if (!sincronizado) {
    sincronizarConGodot();
  } else {
    unsigned long tiempoActual = millis();
    
    // Verificar si es momento de esperar un PING
    if (tiempoActual - ultimoPing >= INTERVALO_PING) {
      // Esperar brevemente por el PING
      for (int i = 0; i < 10; i++) { // Esperar máximo 50ms
        if (Serial.available() > 0) {
          String mensaje = Serial.readStringUntil('\n');
          mensaje.trim();
          if (mensaje == "PING") {
            Serial.println("PONG");
            ultimoPing = tiempoActual;
            break;
          }
        }
        delay(5);
      }
    }
    
    // Leer sensores el resto del tiempo
    leerYEnviarDatos();
  }
  delay(5);
}

void sincronizarConGodot() {
  Serial.println("SYNCHRONIZE");
  unsigned long inicio = millis();
  
  while (millis() - inicio < TIMEOUT) {
    if (Serial.available() > 0) {
      String respuesta = Serial.readStringUntil('\n');
      respuesta.trim();
      if (respuesta == "CONFIRM") {
        sincronizado = true;
        return;
      }
    }
  }
  sincronizado = false;
}

bool verificarConexion() {
  if (Serial.available() > 0) {
    String mensaje = Serial.readStringUntil('\n');
    mensaje.trim();
    if (mensaje == "PING") {
      Serial.println("PONG");
      return true;
    }
  }
  return true; // Asumimos conectado si no hay PING pendiente
}

void leerYEnviarDatos() {
  // Leer teclado
  char tecla = keypad.getKey();
  if (tecla) {
    Serial.print("K:");
    Serial.println(tecla);
  }

  // Leer sensor de agua
  int nivelAgua = analogRead(sensorAguaPin);
  if (nivelAgua > 0) {
    Serial.print("W:");
    Serial.println(nivelAgua);
  }

  // Añadir lectura del potenciómetro
  int valorPotenciometro = analogRead(potenciometroPin);
  if (valorPotenciometro > 0){
    Serial.print("P:");
    Serial.println(valorPotenciometro);
}
