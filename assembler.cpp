#include <iostream>
#include <fstream>
#include <cctype>
#include <string>
using namespace std;
//TODO : function Hex_to_Binary 
//TODO : function RegEx_Index
string Get_Regitser_Index(string Reg_Name){
if(Reg_Name == "R0" || Reg_Name == "r0"){
    return "000";
} 
else if(Reg_Name == "R1" || Reg_Name == "r1" ){
     return "001";
}
else if(Reg_Name == "R2" || Reg_Name == "r2"){
     return "010";
}
else if(Reg_Name == "R3" || Reg_Name == "r3"){
     return "011";
}
else if(Reg_Name == "R4" || Reg_Name == "r4"){
     return "100";
}
else if(Reg_Name == "R5" || Reg_Name == "r5"){
     return "101";
}
else if(Reg_Name == "R6" || Reg_Name == "r6"){
     return "110";
}
else if (Reg_Name == "R7" || Reg_Name == "r7"){
     return "111";
}
else{
 return "error";
}
}

string HexToBin(string hexdec)
{
    long int i = 0;
    string to_binary=""; 
    string concated=""; 
    while (hexdec[i]) {
 
        switch (hexdec[i]) {
        case '0':
        concated = "0000";
        break;
        case '1':
        concated = "0001";
        break;
 
        case '2':
        concated = "0010";
        break;
     
        case '3':
        concated = "0011";
        break;
      
        case '4':
        concated = "0100";
        break;

        case '5':
        concated = "0101";
        break;
      
        case '6':
        concated = "0110";
        break;
      
        case '7':
        concated = "0111";
        break;
         
        case '8':
        concated = "1000";
        break;
        case '9':
        concated = "1001";
        break;
      
        case 'A':
        case 'a':
        concated = "1010";
        break;
            
        case 'B':
        case 'b':
        concated = "1011";
        break;
        case 'C':
        case 'c':
         concated = "1100";
        break;
        case 'D':
        case 'd':
         concated = "1101";
        break;
        case 'E':
        case 'e':
        concated = "1110";
        break;
        case 'F':
        case 'f':
        concated = "1111";
        break;
        default:
        return "Invalid";
        }
        i++;
        to_binary = to_binary + concated;
    }
    while(i<8){
    to_binary = "0000" + to_binary;
    i++;
    }
    if(i==8){
    return to_binary;  
    }
    else{
        return "Invalid";
    }
}

string To_OPcode(string command){
    long int i =0; 
    while(command[i]){
        command[i] = toupper(command[i]);
        i++;
    }
if(command == "NOP"){
    return "0000000";
} 
else if(command == "HLT"){
    return "0000001";
}
else if(command == "SETC"){
    return "0000110";
}
else if(command == "NOT"){
    return "0001111";
}
else if(command == "INC"){
    return "0001000";
}
else if(command == "IN"){
    return "0011000";
}
else if(command == "OUT"){
    return "0010001";
}
else if (command == "MOV"){
    return "0001010";
}
else if (command == "SWAP"){
    return "0001100";
}
else if (command == "ADD"){
    return "0001001";
}
else if (command == "SUB"){
    return "0001101";
}
else if (command == "AND"){
    return "0001011";
}
else if (command == "IADD"){
    return "1001001";
}
else if (command == "PUSH"){
    return "0100010";
}
else if (command == "PUSHI"){
    return "1100010";
}
else if (command == "POP"){
    return "0101101";
}
else if (command == "LDM"){
    return "1001100";
}
else if (command == "LDD"){
    return "1101001";
}
else if (command == "STD"){
    return "1100111";
}
else if (command == "JZ"){
    return "1010000";
}
else if (command == "JN"){
    return "1010001";
}
else if (command == "JC"){
    return "1010010";
}
else if (command == "JMP"){
    return "1010011";
}
else if (command == "CALL"){
    return "1010100";
}
else if (command == "RET"){
    return "0110000";
}
else if (command == "INT"){
    return "1110001";
}
else if (command == "RTI"){
    return "0110001";
}
else{
    return "";
}
} 


int main(int argc, char* argv[]){
	
	return 0;
}