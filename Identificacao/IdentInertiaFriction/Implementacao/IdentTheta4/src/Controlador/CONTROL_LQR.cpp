#include "CONTROL_LQR.hpp"


Control::Control(int numStates, int numInput, int numRef, int numEstadosArtificiais, arma::mat refVal, double timeSample, double forces_trim[2],double angles_trim[2]){

	u0 << forces_trim[0] << endr
	   << forces_trim[1] << endr
	   << (angles_trim[0]*deg2rad) << endr
	   << (angles_trim[1]*deg2rad) << endr;


	error.set_size(numRef,1);
	error.zeros();

	error_int.set_size(numRef,1);
	error_int.zeros();

	ref.set_size(numRef);
	ref = refVal*deg2rad;

	K.set_size(numInput,numStates);
	Ki.set_size(numInput,numRef);

	ifstream in_file;
	in_file.open("Ganho_Estados.txt");
	if (!in_file)
	{
		std::cerr<< "File is not open"<<std::endl;
	}
	for (int i{0}; i<numInput; ++i){
		for (int j{0}; j<numStates; ++j){
			in_file>>K(i,j);
		}
	};
	in_file.close();

	cout << "============================="<< endl;
	cout<< "Ganho K" <<endl;
	cout << "==========="<< endl;
	cout<< K <<endl;

	in_file.open("Ganho_Integral.txt");
	if (!in_file)
	{
		std::cerr<< "File is not open"<<std::endl;
	}
	for (int i{0}; i<numInput; ++i){
		for (int j{0}; j<numRef; ++j){
			in_file>>Ki(i,j);
		}
	};
	in_file.close();


	cout << "============================="<< endl;
	cout<< "Ganho Ki" <<endl;
	cout << "==========="<< endl;
	cout<< Ki <<endl;

	Nx.set_size(numStates,numRef);
	Nx.zeros();

	for(int j{0}; j<numStates; ++j){
		if( j < numRef ){
			Nx(j,j)=1;
		}
	};
	cout << "============================="<< endl;
	cout<< "Ganho Nx" <<endl;
	cout << "==========="<< endl;
	cout<< Nx <<endl;
}

arma::mat Control::computeU(arma::mat States, float Ts){
	//mat Thetas(3,1);
	//mat Estados = trans(States);

	//Thetas(0,0) = States(0);  //Theta1
	//Thetas(1,0) = States(1);  //Theta2
	//Thetas(2,0) = States(2);  //Theta4

	mat Estados(2,1);

	error(0,0) = States(0,0) - ref(0,0); // theta1 - ref1
	error(1,0) = States(0,1) - ref(1,0); // theta2 - ref2
	error(2,0) = States(0,2) - ref(2,0); // theta4 - ref4

	error_int = error_int + Ts*error; // Implementar anti-windup

	Estados << States(0,0) << endr //Theta1
			<< States(0,1) << endr //Theta2
			<< States(0,2) << endr //Theta4
			<< States(0,3) << endr //Theta1 ponto
			<< States(0,4) << endr //Theta2 ponto
			<< States(0,5) << endr;//Theta4 ponto

	return ((u0)+(K*Nx*ref-K*Estados-Ki*error_int));

}

void Control::setRefTheta1(float theta1ref){
	ref(0,0) = theta1ref*deg2rad;
}
void Control::setRefTheta2(float theta1ref){
	ref(1,0) = theta1ref*deg2rad;
}
void Control::setRefTheta4(float theta1ref){
	ref(2,0) = theta1ref*deg2rad;
}
arma::mat Control::getRefinGraus(){
	return(ref*rad2deg);
}


