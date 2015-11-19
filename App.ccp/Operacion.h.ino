#include <WProgram.h> 

class Operacion{
  private:
    int num1;
    int num2;
    int resultado;
  public:
    Operacion (int num1, int num2);
    bool isCorrect(int resultado);
};
Operacion::Operacion(int num1, int num2){
  this->num1 = num1;
  this->num2 = num2;
}
bool Operacion::isCorrect(int resultado){
  if(this->resultado == resultado){
    return true;
  }
  else{
    return false;  
  }
}
