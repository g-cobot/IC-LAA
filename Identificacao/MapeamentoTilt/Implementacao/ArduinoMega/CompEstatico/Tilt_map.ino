/*    Universidade Federal de Uberlandia
       Faculdade de Engenharia Mecanica
          Engenharia Mecatrônica        
          Realizado em 02/12/2019
/*          Realizar o mapeamento estatico do mecanismo tilt */
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

Servo Tilt1; 

//----------------------------------
//    VARIAVEIS GLOBAIS
//---------------------------------- 

float t_k, t_km1 , now, newnow;

float N1=0.2066;
float N2=0.4131;
float N3=0.2066;
      
float C1=1.0000;
float C2=-0.3695;
float C3=0.1958;
float deltaT;
float Ta =0.05;//[segundos]
int j=0;

int i=0;
int potPin = 0;

//----------------------------------
//   VARIAVEL DE COMANDO
//----------------------------------
float U_0=1000;
float U=1000;
float pwm=1650;
int command=0;
float u_k=0;
float u_km1=0;


//----------------------------------
//   VARIAVEL DE ESTADO
//----------------------------------
int tilt_out=0;
int tilt_k=0;
int tilt_km1=0;
int tilt_km2=0;
int ttilt_km2=0;
int ttilt_km1=0;
float tilt_2_angle=4;
int alt = 50;

//----------------------------------
//    VOID SETUP
//----------------------------------


void setup() {
  
  
  Serial.begin(115200);
  
  Tilt1.attach (8); //attach the motor
  Tilt1.writeMicroseconds(1650); // Tilt Initialization

  t_k=millis();
  delay(250);
}

//----------------------------------
//    VOID LOOP
//----------------------------------


void loop() {
   t_k=millis();
   
   if(((i%alt)==0)&&(i<14*alt)){
    pwm=pwm+50;
    saturacao();
    Tilt1.writeMicroseconds(pwm); // Tilt Initialization
   }
   else if(((i%alt)==0)&&(i<28*alt)){
    pwm=pwm-50;
    saturacao();
    Tilt1.writeMicroseconds(pwm); // Tilt Initialization
   }
   readSensor();
   printInfo();

   while( (millis()- t_k)/1000 < Ta)
        {
          //Wait for the next amostragem 
        }
   i++;
}

//----------------------------------
//    SUBROTINAS
//----------------------------------

void saturacao(){
  
  /*Saturaçao da variavel de comando entre 1650us e 2350us*/
 
  if(pwm > 2350)
  {
    pwm = 1650;
  }
  if(pwm < 1650)
  {
   pwm=1650;
  }
}

void printInfo(){
  Serial.print((millis()/1000.00),5);
  Serial.print("\t ");  
  Serial.print(pwm);
  Serial.print("\t ");
  Serial.print(tilt_out);
  Serial.print("\t ");
  Serial.print(tilt_out*tilt_2_angle);
  Serial.print("\t ");
  Serial.print(i);
  Serial.print("\t ");
  Serial.println(((millis()-t_k)/1000.00),5);
  
}

void readSensor(){
  tilt_out = analogRead(potPin); // read the value from potentiometer
  //tilt_out = ( (N1)* tilt_k + (N2) * tilt_km1 + (N3) * tilt_km2 - C2 * ttilt_km1 - C3 * ttilt_km2 )/(C1);
  //tilt_km2=tilt_km1;
  //tilt_km1=tilt_k;
  //ttilt_km2=ttilt_km1;
  //ttilt_km1=tilt_out;
}
