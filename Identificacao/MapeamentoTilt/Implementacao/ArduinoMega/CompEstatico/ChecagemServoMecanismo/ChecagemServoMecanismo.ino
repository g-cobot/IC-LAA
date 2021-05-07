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
   
   if(i<1600){
    ppm=ppm+i;
    saturacao();
    servo.writeMicroseconds(ppm); // Tilt Initialization
   }
   else if(i<3200){
    ppm=ppm-i;
    saturacao();
    servo.writeMicroseconds(ppm);
   }
   else{
    i=0;
   }
 
   readSensor();
  
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
 
  if(ppm > 2350)
  {
    ppm = 2350;
  }
  if(ppm < 650)
  {
   ppm=2350;
  }
}

void printInfo(){
  Serial.print((millis()/1000.00),5);
  Serial.print("\t ");
  Serial.print(theta_pot);
  Serial.print("\t "); 
  Serial.print(ppm);
  Serial.print("\t ");
  Serial.print(theta_servo);
  Serial.print("\t ");
  Serial.println(   ( (millis()-t_k)/1000.00 )  ,4);
  
}

float ADC2thetaPot(float x,float a, float b) {
  return (x*a+b);
}
void readSensor(){
  theta_pot = ADC2thetaPot(analogRead(potPin), a, b);
  theta_servo = theta_pot*coef_ang+coef_lin;
}
