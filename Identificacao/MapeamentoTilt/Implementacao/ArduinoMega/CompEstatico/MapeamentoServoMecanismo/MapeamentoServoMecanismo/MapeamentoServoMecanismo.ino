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

float Ta        = 0.25 ;       //[segundos]

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
int   theta_servo = 0;
float theta_pot   = 0;

// potenciometro
float a = 0.2586;
float b = 47.2534 ;

//----------------------------------
//    VOID SETUP
//----------------------------------


void setup() {
  
  
  Serial.begin(115200);
  
  servo.attach (8);             // Ligacao do servo
  servo.writeMicroseconds(650);   // Inicializacao do servo

  delay(250);
}

//----------------------------------
//    VOID LOOP
//----------------------------------


void loop() {
   t_k=millis();
   if(Serial.available()){
    for (int i=0; i<5; i++) {
      value[i] = Serial.read();
    }
    ppm   =  atoi(value);
    saturacao();
    servo.writeMicroseconds(ppm);
   }
   readSensor();
   printInfo();
   while( ((millis()- t_k)/1000) < Ta )
      {
          //amostragem 
      }
}

//----------------------------------
//    SUBROTINAS
//----------------------------------

void saturacao(){
  
  /*Saturaçao da variavel de comando entre 1650us e 2350us*/
 
  if(ppm > 2350)
  {
    ppm = 2350;
  }
  if(ppm < 650)
  {
   ppm=650;
  }
}

void printInfo(){
  Serial.print((millis()/1000.00),5);
  Serial.print("\t ");
  Serial.print(((millis()-t_k)/1000.00) ,4);
  Serial.print("\t ");
  Serial.print(theta_pot);
  Serial.print("\t "); 
  Serial.println(ppm);
}

float ADC2thetaPot(float x,float a, float b) {
  return (x*a+b);
}
void readSensor(){
  theta_pot = ADC2thetaPot(analogRead(potPin), a, b);
}
