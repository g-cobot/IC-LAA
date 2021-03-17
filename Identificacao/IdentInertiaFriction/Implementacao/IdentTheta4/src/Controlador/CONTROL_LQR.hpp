/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

#ifndef CONTROL_THETA4_LQR_HPP
#define CONTROL_THETA4_LQR_HPP

#include <fstream>
#include <armadillo>
#include <vector>
#include <iostream>
#include <string>

#define rad2deg (180/3.14159265358979323846)
#define deg2rad (3.14159265358979323846/180)

using namespace std;
using namespace arma;

class Control{
	private:
		mat u0;
		mat Kp;
		mat K;
		mat Ki;
		mat error;
		mat error_int;
		mat ref;
		mat Nx;

	public:
		Control(int numStates, int numInput, int numRef, int numEstadosArtificiais, arma::mat refVal, double timeSample, double forces_trim[2],double angles_trim[2]);
		arma::mat computeU(arma::mat States, float Ts);
		arma::mat getRef();
		arma::mat getRefinGraus();
		void setRefTheta1(float ref);
		void setRefTheta2(float ref);
		void setRefTheta4(float ref);
};

#endif
