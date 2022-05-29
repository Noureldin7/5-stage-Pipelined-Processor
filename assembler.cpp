#include <iostream>
#include <fstream>
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

int main(int argc, char* argv[]){
	
	return 0;
}