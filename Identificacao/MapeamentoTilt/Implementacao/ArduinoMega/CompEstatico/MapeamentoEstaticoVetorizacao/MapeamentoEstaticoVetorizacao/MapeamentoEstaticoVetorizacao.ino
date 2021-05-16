/*    Universidade Federal de Uberlandia
       Faculdade de Engenharia Mecanica
          Engenharia Mecatrônica        
          Realizado em 06/05/2021
/* Realizar o mapeamento estatico do mecanismo tilt */
//----------------------------------
//    BIBLIOTECAS
//----------------------------------

#include <SPI.h>
#include <Wire.h>
#include <Servo.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>

//----------------------------------
//    OBJETOS
//----------------------------------

Servo servo; 

//----------------------------------
//    VARIAVEIS GLOBAIS
//---------------------------------- 

float t_k;

float Ta        = 1.50 ;       //[segundos]

int i      = 0;
int potPin = 0;
char value[5] = {'1','2','1','5','6'};
//char *value;
//----------------------------------
//   VARIAVEL DE COMANDO
//----------------------------------

float ppm=1500;

//----------------------------------
//   VARIAVEIS
//----------------------------------
float   thetaServo = 60.0;
float theta_pot   = 0;


// servo
//0.109996532344479 -83.386358264006333
//9.084107327141382

float a = 9.08411;
float b = 758.6842;

// potenciometro
//0.109996532344479 -83.386358264006333
float ag = 0.11000;
float bg = -83.38636;

//----------------------------------
//    VOID SETUP
//----------------------------------


void setup() {
  
  
  Serial.begin(115200);
  
  servo.attach (8);             // Ligacao do servo
  servo.writeMicroseconds(ppm);   // Inicializacao do servo

  delay(250);
}

//----------------------------------
//    VOID LOOP
//----------------------------------


void loop() {
   t_k=millis();
   //if(Serial.available()){
   // for (int i=0; i<5; i++) {
   //   value[i] = Serial.read();
   // }
   // thetaServo   =  (atoi(value)/1.0);
   // ppm = thetaServo2PPM(thetaServo,a,b);
   // saturacao();
   // servo.writeMicroseconds(ppm);
   //}

   if(i<25){
     thetaServo   =  thetaServo+5;
   }
   else if(i<50){
    thetaServo   =  thetaServo-5;
   }
   else{
    i=0;
   }
   ppm = thetaServo2PPM(thetaServo,a,b);
   saturacao();
   servo.writeMicroseconds(ppm);
   while( ((millis()- t_k)/1000) < Ta )
      {
          //amostragem 
      }
   printInfo();
   i++;
}

//----------------------------------
//    SUBROTINAS
//----------------------------------

void saturacao(){
  
  /*Saturaçao da variavel de comando entre 1650us e 2350us*/
 
  if(ppm > 2600)
  {
    ppm = 2600;
  }
  if(ppm < 1320)
  {
   ppm=1320;
  }
}

void printInfo(){
  Serial.print((millis()/1000.00),5);
  Serial.print("\t ");
  Serial.print(((millis()-t_k)/1000.00) ,4);
  Serial.print("\t ");
  Serial.print(analogRead(potPin));
  Serial.print("\t ");
  Serial.print(ppm);
  Serial.print("\t ");
  Serial.println(thetaServo);
}

float thetaServo2PPM(float x,float a, float b) {
  return (x*a+b);
}
float ADC2thetaPot(float x,float a, float b) {
  return (x*a+b);
}
void readSensor(){
  theta_pot = ADC2thetaPot(analogRead(potPin), ag, bg);
}
