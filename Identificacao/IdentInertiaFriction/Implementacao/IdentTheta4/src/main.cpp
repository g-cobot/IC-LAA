//============================================================================
// Name        : Theta4_Control.cpp
// Author      : Gabrieis
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <armadillo>
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <unistd.h>
#include "Sensor/SENSORS.hpp"
#include "Atuador/MOTOR.hpp"
#include "Atuador/SERVO.hpp"
#include "Controlador/CONTROL_LQR.hpp"

using namespace std;
using namespace arma;


void printData(const int contador, const arma::mat estado, const arma::mat comando_x, const arma::mat referencia){
	mat comando = comando_x;
	const int field1 {10};
	cout<< setprecision(3)<<fixed;
	cout<< setw(field1) << left << "Interacao ";
	cout<< setw(field1) << left << contador;
	cout<<endl;
	cout<< setw(field1) << left << "Estados ";

	for (int i{0}; i<estado.n_elem; ++i){
		cout<< setw(field1) << left <<estado(i)*(180/3.1415);
	}
	cout<<endl;
	cout<< setw(field1) << left << "Comandos ";
	comando(2) = comando(2)*180/3.14159265358979323846;
	comando(3) = comando(3)*180/3.14159265358979323846;
	for (int i{0}; i<comando.n_elem; ++i){
		cout<< setw(field1) << left <<comando(i);
	}

	cout<<endl;

	cout<< setw(field1) << left << "Referencias ";

	for (int i{0}; i<referencia.n_elem; ++i){
		cout<< setw(field1) << left <<referencia(i);
	}

	cout<<endl;
}


void waitSample(float ti,double dt)
{
	float time_taken = 0;
	float tf =0;

	while (time_taken < dt*1000000){
		tf = clock();
		time_taken = (tf-ti);
	}
}

#define P9_42 "P9.42"  // pwmchip1 pwm0 pin P9.42 para o motor1
#define P9_22 "P9.22"  // pwmchip0 pwm0 pin P9.22 para o motor2

#define coef_a_motor1 0.000386794285714
#define coef_b_motor1 0.044941011428573
#define coef_c_motor1 -1.149182640000060

#define coef_a_motor2 0.000617749714286
#define coef_b_motor2 0.020354348571431
#define coef_c_motor2 -0.502036560000080


#define P8_13 "P8.13"  // pwmchip6 pwm0 pin P8.13 para o servo1
#define P8_19 "P8.19"  // pwmchip6 pwm1 pin P8.19 para o servo2


#define coef_a_servo2 0.0000000000396
#define coef_b_servo2 -0.0002146384033
#define coef_c_servo2 280.8235824934203

#define coef_a_servo1 0.0000000000225
#define coef_b_servo1 -0.0001508455823
#define coef_c_servo1 229.8191731868040


// Inicializacao de variaveis

int numit, numInitIMU, trim;
double dt;
int in{1};
string file2save;
vector<double> imu_theta4;
vector<double> enc_theta12;
vector<double> rateNoFilter;
clock_t t0, tend;
int numStates{6},numInput{4},numRef{3},numEstadosArtificiais{3};
mat Forces_Angles(4,1);
double forces_trim[2];
double angles_trim[2];
mat Ref(3,1);
float ref1;
float ref2;
float ref4;

int main() {

	ifstream parametros_sistema;
	parametros_sistema.open("parametros_sistema.txt",ifstream::in);

	if (parametros_sistema.is_open())
	{
		parametros_sistema>> dt;         		   //time sample
		parametros_sistema>> numit;      		   //number of iterations
		parametros_sistema>> numInitIMU; 		   // number of initalization
		parametros_sistema>> forces_trim[0];       // PWM value at hoover condition
		parametros_sistema>> forces_trim[1];       // PWM value at hoover condition
		parametros_sistema>> angles_trim[0];       // Angle alpha 1 in deg
		parametros_sistema>> angles_trim[1];       // Angle alpha 2 in deg
		parametros_sistema>> file2save; 		   // file to save data name
		parametros_sistema>> Ref(0,0);   		       // Theta1 reference value
		parametros_sistema>> Ref(1,0);  		   // Theta2 reference value
		parametros_sistema>> ref4; 		           // Theta4 reference value
	}
	else{
		cerr << "Arquivo nao existente ou nao encontrado! "<< endl;
		return 1;
	}

	Ref(2,0)=0;

	parametros_sistema.close();
	cout << "============================="<< endl;
	cout << "Parametros Iniciais"<< endl;
	cout << "============="<< endl;
	cout << "Nome do ensaio "<< file2save <<  endl;
	cout << "            Ts "<< dt <<  endl;
	cout << "============================="<< endl;
	cout << "Parametros de trimagem"<< endl;
	cout << "============="<< endl;
	cout << "   F1    F2 "<< forces_trim[0] << "\t" << forces_trim[1]<<  endl;
	cout << "alfa1 alfa2 "<< angles_trim[0] << "\t" << angles_trim[1] <<  endl;
	cout << "============================="<< endl;
	cout << "Referencias"<< endl;
	cout << "============="<< endl;
	cout << "k = 0"<< endl;
	cout << "Referencia Theta 1 [graus] "<< Ref(0,0)<<  endl;
	cout << "Referencia Theta 2 [graus] "<< Ref(1,0) <<  endl;
	cout << "Referencia Theta 4 [graus] "<< Ref(2,0) <<  endl;
	cout << "============="<< endl;
	cout << "k = 300"<< endl;
	cout << "Referencia Theta 1 [graus] "<< ref1<<  endl;
	cout << "Referencia Theta 2 [graus] "<< Ref(1,0) <<  endl;
	cout << "Referencia Theta 4 [graus] "<< Ref(2,0) <<  endl;

	mat estados(numit,6,fill::zeros);
	mat comandos(numit,4,fill::zeros);
	mat cpu_time = zeros<mat>(numit,1);
	clock_t tictoc;

	Sensors sensores(dt);

	sensores.imuInitialization();

	Control controle(numStates, numInput, numRef, numEstadosArtificiais, Ref, dt, forces_trim, angles_trim);

	cout << "Pressione 0 para testar funcionamento dos servos"<< endl;
	while (in!=0)
	{
		cin>>in;
	}

	Motor motor1(P9_42,coef_a_motor1,coef_b_motor1,coef_c_motor1);
	Motor motor2(P9_22,coef_a_motor2,coef_b_motor2,coef_c_motor2);

	Servo servo1(P8_13,coef_a_servo1,coef_b_servo1,coef_c_servo1);
	Servo servo2(P8_19,coef_a_servo2,coef_b_servo2,coef_c_servo2);

	int i=0;
	int numdiv=45;
	for(i=1;i<=numdiv;i++)
	{
		t0 = clock();
		waitSample(t0,dt);
		servo1.setAngleinDeg((angles_trim[0]-10+i));
	}

	for(i=1;i<=numdiv;i++)
	{
		t0 = clock();
		waitSample(t0,dt);
		servo2.setAngleinDeg((angles_trim[0]-10+i));
	}

	cout << "Pressione 1 para inicializar os servos na posicao de trimagem"<< endl;
	while (in!=1)
	{
		cin>>in;
	}

	// Angulo de tilt inicial

	servo1.setAngleinDeg(angles_trim[0]);
	servo2.setAngleinDeg(angles_trim[1]);


	cout << "Pressione 2 para inicializar os motores em velocidade minima"<< endl;

	while (in!=2)
	{
		cin>>in;
	}

	int contador = 0;

	motor1.setInitialMovement();
	motor2.setInitialMovement();

	cout << "Pressione 3 para aplicar as forcas de trimagem nos motores"<< endl;


	while (in!=3)
	{
		cin>>in;
	}


	numdiv=30;
	for(i=1;i<=numdiv;i++)
	{
		t0 = clock();
		waitSample(t0,dt);
		motor1.reachTrimForceinNewton((forces_trim[0]*i/numdiv));
		motor2.reachTrimForceinNewton((forces_trim[1]*i/numdiv));

	}

	while (contador < 100)
	{
		t0 = clock();
		imu_theta4 = sensores.imuRawData(); // return accelerations, angular velocities an non-filtered angles
		imu_theta4 = sensores.imuFilteredData(imu_theta4);

		const int field1 {10};
		cout<< setprecision(3)<<fixed;
		cout<< setw(field1) << left << "Theta ";
		cout<< setw(field1) << left <<imu_theta4[0];
		cout<< endl;

		contador++;
		sensores.waitSample(t0);
	}


	sensores.encoderInitialPosition();

	std::cout << "Pressione 4 para inicializar o experimento!"<< std::endl;
	while (in!=4)
	{
		cin>>in;
		t0 = clock();
		imu_theta4 = sensores.imuRawData(); // return accelerations, angular velocities an non-filtered angles
		imu_theta4 = sensores.imuFilteredData(imu_theta4);

		const int field1 {10};
		cout<< setprecision(3)<<fixed;
		cout<< setw(field1) << left << "Theta 4 ";
		cout<< setw(field1) << left <<imu_theta4[0];
		cout<< endl;
		sensores.waitSample(t0);
	}

	contador = 0;

	while (contador < numit)
	{
		tictoc = clock();
		t0 = clock();
		if(contador==300){

			controle.setRefTheta4(ref4);

		}

		imu_theta4 =sensores.imuRawData(); // return accelerations, angular velocities an non-filtered angles

		imu_theta4 =sensores.imuFilteredData(imu_theta4); // return filtered roll and pitch angles and rates  x = [roll,roll_rate, pitch, pitch_rate];

		enc_theta12 =sensores.encoderPosition();  // return encoder angular position and rates x = [theta_1, theta_1_rate, theta_2, theta_2_rate];

		sensores.getStateVector(imu_theta4,enc_theta12,estados,contador);

		// apply move average filter to velocity vector
		sensores.moveMean(estados,5,contador);

		//sensores.printData(estados.row(contador));

		Forces_Angles = controle.computeU(estados.row(contador), dt);

		comandos(contador,0) = Forces_Angles(0,0); // F1
		comandos(contador,1) = Forces_Angles(1,0); // F2
		comandos(contador,2) = Forces_Angles(2,0); // alpha1 in rad
		comandos(contador,3) = Forces_Angles(3,0); // alpha2 in rad

		tictoc = clock()-tictoc;
		cpu_time(contador) = ((float)tictoc)/CLOCKS_PER_SEC*1000000;
		// Aplicando comandos nos atuadores

		motor2.setForceinNewton(Forces_Angles(1,0));
		motor1.setForceinNewton(Forces_Angles(0,0));

		servo2.setAngleinDeg((Forces_Angles(3,0)*rad2deg));
		servo1.setAngleinDeg((Forces_Angles(2,0)*rad2deg));


		printData(contador,estados.row(contador),comandos.row(contador), controle.getRefinGraus());

		sensores.waitSample(t0);

		contador++;

	}

	cout << "Salvando Dados" << endl;

	estados.col(0) = estados.col(0)*rad2deg;
	estados.col(1) = estados.col(1)*rad2deg;
	estados.col(2) = estados.col(2)*rad2deg;

	comandos.col(2) = comandos.col(2)*rad2deg;
	comandos.col(3) = comandos.col(3)*rad2deg;

	mat data_total=join_horiz(estados,comandos);
	data_total=join_horiz(data_total,cpu_time);

	ofstream salvaDados(file2save);

	if (!salvaDados)
	{
		cerr << "Arquivo de salvaDados nao foi criado! "<< endl;
	}
	else
	{
		for (int i{0}; i<numit; ++i)
		{
			salvaDados << data_total.row(i);
		}

	}
	salvaDados.close();


	cout << "Desativando Motores e Servos" << endl;

	motor1.setForceinNewton(forces_trim[0]);
	motor2.setForceinNewton(forces_trim[1]);

	servo1.setAngleinDeg(0);
	servo2.setAngleinDeg(0);

	std::cout << "Pressione 5 para finalizar o experimento!"<< std::endl;
	while (in!=5)
	{
		cin>>in;
	}

	motor1.setInitialMovement();
	motor2.setInitialMovement();

	while( (i < 150) )
	{
		t0 = clock();
		waitSample(t0,dt);
		i++;
	}

	motor2.deactivate();
	motor1.deactivate();

	servo2.deactivate();
	servo1.deactivate();

	return 0;
}


