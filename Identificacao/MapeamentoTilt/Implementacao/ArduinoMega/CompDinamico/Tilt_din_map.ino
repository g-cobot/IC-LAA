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
Servo Motor1;


//----------------------------------
//    VARIAVEIS GLOBAIS
//---------------------------------- 

float t_k, t_km1 , now, newnow;

float N1=0.2066;
float N2=0.4131;
float N3=0.2066;
float val = 0;  
float C1=1.0000;
float C2=-0.3695;
float C3=0.1958;
float deltaT;
float Ta =0.025;//[segundos]
int j=0;


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
int flag=0;
int i=0;


float a1 = -0.2818 ;
float b1 = 73.1753 ;


float a2 = -0.2751 ;
float b2 = 273.1069 ;
//----------------------------------
//    VOID SETUP
//----------------------------------


void setup() {
  
  
  Serial.begin(115200);
  
  Tilt1.attach(8); //attach the motor
  Motor1.attach(2); //attach the motor

  Tilt1.writeMicroseconds(1650); // Tilt Initialization
  Motor1.writeMicroseconds(1); // Motor Initialization
  delay(2000);
 
  t_k=millis();
  Motor1.writeMicroseconds(1150); // Motor Initialization
  delay(2000);
  Motor1.writeMicroseconds(1350); // Motor Initialization
  delay(2000);
}

//----------------------------------
//    VOID LOOP
//----------------------------------


void loop() {
   t_k=millis();
  if(i<700){
   flag=1;
   pwm=pwm+1;
   saturacao();
   Tilt1.writeMicroseconds (pwm);
   }
   else if(i==1400){
    flag=-1;
    pwm=1650;
    saturacao();
    Tilt1.writeMicroseconds (pwm);
    Motor1.writeMicroseconds(1);
    }
   else if(i>700){
    flag=-1;
    pwm=pwm-1;
    saturacao();
    Tilt1.writeMicroseconds (pwm);
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
  
  /*Saturaçao da variavel de comando entre 1000us e 2000us*/
  // MOTOR 1 PRETO
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
  Serial.print(getAngle(2,tilt_out));
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

float getAngle(int m1, float LAD){
  if(m1==1){
    val = a1*LAD+b1;
  }
  else{
    val = a2*LAD+b2;
  }
  return(val);  
  }

/*
  if(i==200){
   flag=1;
   pwm=1800;
   saturacao();
   Tilt1.writeMicroseconds (pwm);
   }
   else if(i==400){
    flag=-1;
    pwm=1650;
    saturacao();
    Tilt1.writeMicroseconds (pwm);
    }
   else if(i==600){
    flag=-1;
    pwm=2350;
    saturacao();
    Tilt1.writeMicroseconds (pwm);
    }
    else if(i==800){
    flag=-1;
    pwm=1650;
    saturacao();
    Tilt1.writeMicroseconds (pwm);
    Motor1.writeMicroseconds (1);
    }
    */
