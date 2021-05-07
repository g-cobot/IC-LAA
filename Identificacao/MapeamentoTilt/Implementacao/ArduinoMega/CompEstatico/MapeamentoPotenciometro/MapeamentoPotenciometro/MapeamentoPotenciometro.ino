/*    Universidade Federal de Uberlandia
       Faculdade de Engenharia Mecanica
          Engenharia Mecatrônica        
          Realizado em 06/05/2021
/* Realizar a calibracao do potenciometro */
/* Variar o ângulo de medição de 5 em 5 graus e anotar o resultado ADC*/
/* Repetir 3 vezes no range do valor mínimo do potenciometro a 180 graus*/
/* Normalmente os 90 primeiros graus não servem para nada */
/* SUBROTINAS */
float floatMap(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
/* DECLARACAO DE VARIAVEIS */
int analogValue = 0;
float voltage   = 0;

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(115200);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin A0:
  analogValue = analogRead(A0);
  // Rescale to potentiometer's voltage (from 0V to 5V):
  voltage = floatMap(analogValue, 0, 1023, 0, 5);
  // print out the value you read:
  Serial.print((millis()/1000.00),5);
  Serial.print('\t');
  Serial.print(voltage);
  Serial.print('\t');
  Serial.println(analogValue);
  delay(1000);
}
