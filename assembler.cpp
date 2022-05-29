#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <iterator>
#include <map>
using namespace std;

struct MemEntry
{
	int index;
	string value;
};

string Get_Regitser_Index(string Reg_Name)
{
	if (Reg_Name == "R0" || Reg_Name == "r0")
	{
		return "000";
	}
	else if (Reg_Name == "R1" || Reg_Name == "r1")
	{
		return "001";
	}
	else if (Reg_Name == "R2" || Reg_Name == "r2")
	{
		return "010";
	}
	else if (Reg_Name == "R3" || Reg_Name == "r3")
	{
		return "011";
	}
	else if (Reg_Name == "R4" || Reg_Name == "r4")
	{
		return "100";
	}
	else if (Reg_Name == "R5" || Reg_Name == "r5")
	{
		return "101";
	}
	else if (Reg_Name == "R6" || Reg_Name == "r6")
	{
		return "110";
	}
	else if (Reg_Name == "R7" || Reg_Name == "r7")
	{
		return "111";
	}
	else
	{
		return "Invalid";
	}
}

string HexToBin(string hexdec)
{
	long int i = 0;
	string to_binary = "";
	string concated = "";
	while (hexdec[i])
	{

		switch (hexdec[i])
		{
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
	while (i < 8)
	{
		to_binary = "0000" + to_binary;
		i++;
	}
	if (i == 8)
	{
		return to_binary;
	}
	else
	{
		return "Invalid";
	}
}

// Operands[0]
// Operands[1]
// Operands[2]
// Imm
// D, T, S, I, O
string To_OPcode(string command, string *Operands, string &Imm)
{
	if (command == "NOP")
	{
		Operands[0] = "";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0000000";
	}
	else if (command == "HLT")
	{
		Operands[0] = "";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0000001";
	}
	else if (command == "SETC")
	{
		Operands[0] = "";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0000110";
	}
	else if (command == "NOT")
	{
		Operands[0] = "DT";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0001111";
	}
	else if (command == "INC")
	{
		Operands[0] = "DT";
		Operands[1] = "";
		Operands[2] = "";
		Imm = HexToBin("1");
		return "0001000";
	}
	else if (command == "DEC")
	{
		Operands[0] = "DT";
		Operands[1] = "";
		Operands[2] = "";
		Imm = HexToBin("1");
		return "0000000";
	}
	else if (command == "IN")
	{
		Operands[0] = "D";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0011000";
	}
	else if (command == "OUT")
	{
		Operands[0] = "S";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0010001";
	}
	else if (command == "MOV")
	{
		Operands[0] = "S";
		Operands[1] = "D";
		Operands[2] = "";
		Imm = "";
		return "0001010";
	}
	else if (command == "SWAP")
	{
		Operands[0] = "S";
		Operands[1] = "T";
		Operands[2] = "";
		Imm = "";
		return "0001100";
	}
	else if (command == "ADD")
	{
		Operands[0] = "D";
		Operands[1] = "S";
		Operands[2] = "T";
		Imm = "";
		return "0001001";
	}
	else if (command == "SUB")
	{
		Operands[0] = "D";
		Operands[1] = "S";
		Operands[2] = "T";
		Imm = "";
		return "0001101";
	}
	else if (command == "AND")
	{
		Operands[0] = "D";
		Operands[1] = "S";
		Operands[2] = "T";
		Imm = "";
		return "0001011";
	}
	else if (command == "IADD")
	{
		Operands[0] = "D";
		Operands[1] = "S";
		Operands[2] = "I";
		Imm = "";
		return "1001001";
	}
	else if (command == "PUSH")
	{
		Operands[0] = "D";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0100010";
	}
	else if (command == "POP")
	{
		Operands[0] = "D";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0101101";
	}
	else if (command == "LDM")
	{
		Operands[0] = "D";
		Operands[1] = "I";
		Operands[2] = "";
		Imm = "";
		return "1001100";
	}
	else if (command == "LDD")
	{
		Operands[0] = "D";
		Operands[1] = "O";
		Operands[2] = "";
		Imm = "";
		return "1101001";
	}
	else if (command == "STD")
	{
		Operands[0] = "S";
		Operands[1] = "O";
		Operands[2] = "";
		Imm = "";
		return "1100111";
	}
	else if (command == "JZ")
	{
		Operands[0] = "I";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "1010000";
	}
	else if (command == "JN")
	{
		Operands[0] = "I";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "1010001";
	}
	else if (command == "JC")
	{
		Operands[0] = "I";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "1010010";
	}
	else if (command == "JMP")
	{
		Operands[0] = "I";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "1010011";
	}
	else if (command == "CALL")
	{
		Operands[0] = "I";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "1010100";
	}
	else if (command == "RET")
	{
		Operands[0] = "";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0110000";
	}
	else if (command == "INT")
	{
		Operands[0] = "I";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "1110001";
	}
	else if (command == "RTI")
	{
		Operands[0] = "";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "0110001";
	}
	else
	{
		Operands[0] = "";
		Operands[1] = "";
		Operands[2] = "";
		Imm = "";
		return "Invalid";
	}
}

// returns -1 for wrong syntax line,
// 0 for empty or commented lines,
// 1 for meaningful lines
int readLine(ifstream &inputFile, string *words)
{
	char nextChar;
	string line;
	int counter = 0;
	getline(inputFile, line, '\n');
	while (!line.empty())
	{
		nextChar = line.front();
		line.erase(0, 1);
		if (nextChar == '#')
			break;
		if (counter != 0 && (nextChar == ' ' || nextChar == '\t'))
		{
			nextChar = line.front();
			while (!line.empty())
			{
				if (nextChar == '#')
					break;
				else if (nextChar != ' ' && nextChar != '\t')
					return -1;
				line.erase(0, 1);
				nextChar = line.front();
			}
		}
		else if (counter == 0 && (nextChar == ' ' || nextChar == '\t'))
		{
			if (!words[0].empty())
				counter++;
			nextChar = line.front();
			while (!line.empty())
			{
				if (isalnum(nextChar) || nextChar == '#')
					break;
				else if (nextChar != ' ')
					return -1;
				line.erase(0, 1);
				nextChar = line.front();
			}
		}
		else if ((counter == 1 || counter == 2) && nextChar == ',')
		{
			if (!words[0].empty())
				counter++;
			nextChar = line.front();
			while (!line.empty())
			{
				if (isalnum(nextChar))
					break;
				else if (nextChar != ' ' && nextChar != '\t')
					return -1;
				line.erase(0, 1);
				nextChar = line.front();
			}
		}
		else if (counter < 4 && (isalnum(nextChar) || nextChar == '(' || nextChar == ')' || nextChar == '.'))
		{
			words[counter].push_back(nextChar);
		}
		else
			return -1;
	}
	if (words[0].empty())
		return 0;
	return 1;
}

// returns -1 for wrong syntax instruction,
// 1 for meaningful instruction
int readIns(ifstream &inputFile, string *words, MemEntry &output)
{
	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < words[i].length(); j++)
		{
			words[i][j] = toupper(words[i][j]);
		}
	}
	string opcode, immediate = HexToBin("0"), immediateTemp, Rt = "000", Rs = "000", Rd = "000";
	string operands[3];
	opcode = To_OPcode(words[0], operands, immediateTemp);
	if (opcode == "Invalid")
	{
		return -1;
	}
	for (int i = 0; i < 3; i++)
	{
		if (operands[i].empty() != words[i + 1].empty())
		{
			return -1;
		}
		if (!operands[i].empty() && !words[i + 1].empty())
		{
			for (int j = 0; j < operands[i].length(); j++)
			{
				if (operands[i][j] == 'S')
					Rs = Get_Regitser_Index(words[i + 1]);
				else if (operands[i][j] == 'D')
					Rd = Get_Regitser_Index(words[i + 1]);
				else if (operands[i][j] == 'T')
					Rt = Get_Regitser_Index(words[i + 1]);
				else if (operands[i][j] == 'I')
					immediate = HexToBin(words[i + 1]);
				else if (operands[i][j] == 'O')
				{
					immediate = HexToBin(words[i + 1].substr(0, words[i + 1].find('(') - 1));
					Rt = Get_Regitser_Index(words[i + 1].substr(words[i + 1].find('(') + 1, words[i + 1].find(')') - words[i + 1].find('(') - 1));
					if (words[i + 1].find(')') == words[i + 1].length() - 2)
					{
						return -1;
					}
				}
			}
		}
	}
	if (Rs == "Invalid" || Rd == "Invalid" || Rt == "Invalid" || immediateTemp == "Invalid")
	{
		return -1;
	}
	if (!immediateTemp.empty())
		immediate = immediateTemp;
	immediate = immediate.erase(0, 16);
	output.value = opcode + Rd + Rt + Rs + immediate;
	return 1;
}

// returns -1 for wrong syntax instruction,
// 0 for empty or commented lines,
// 1 for meaningful instruction
int writeInMem(ifstream &inputFile, MemEntry &output, int &currentAddress, int &lineNum)
{

	// parsing
	string words[4];
	int outcome;
	do
	{
		lineNum++;
		outcome = readLine(inputFile, words);
	} while (outcome == 0 && inputFile);
	if (!inputFile)
		return 0;
	if (outcome == -1)
	{
		return -1;
	}
	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < words[i].length(); j++)
		{
			words[i][j] = toupper(words[i][j]);
		}
	}

	// making sense of what we parsed
	if (words[0] == ".ORG")
	{
		stringstream ss;
		ss << hex << words[1];
		ss >> output.index;
		cout << "Instruction Index: " << output.index << endl;
		if (!words[2].empty() || !words[3].empty())
		{
			return -1;
		}
		if (output.index <= 4 && output.index >= 0)
		{
			string number;
			lineNum++;
			getline(inputFile, number, '\n');
			output.value = HexToBin(number);
			if (output.value == "Invalid")
			{
				return -1;
			}
			return 1;
		}
		else
		{
			string new_words[4];
			int outcome;
			do
			{
				lineNum++;
				outcome = readLine(inputFile, new_words);
			} while (outcome == 0 && inputFile);
			if (!inputFile)
				return 0;
			if (outcome == -1)
			{
				return -1;
			}
			if (readIns(inputFile, new_words, output) == -1)
			{
				return -1;
			}
			return 1;
		}
	}
	else
	{
		output.index = currentAddress + 1;
		if (readIns(inputFile, words, output) == -1)
		{
			return -1;
		}
		return 1;
	}
}

int main(int argc, char *argv[])
{
	map<int, string> Memory;
	if (argc != 3)
	{
		cout << "Invalid Inputs" << endl;
		return 0;
	}
	ifstream inputFile(argv[1]);
	if (!inputFile)
	{
		cout << "Invalid Input File" << endl;
		return 0;
	}
	int currentAddress = 0x1000;
	int lineNum = 0;
	while (inputFile)
	{
		MemEntry output;
		currentAddress = output.index;
		int state = writeInMem(inputFile, output, currentAddress, lineNum);
		if (state == 1)
		{
			Memory.insert(pair<int, string>(output.index, output.value));
			cout << "At Index: " << output.index << ", Instruction: " << output.value << endl;
		}
		else if (state == -1)
		{
			cout << "Error at line " << lineNum << endl;
			inputFile.close();
			return 0;
		}
	}
	inputFile.close();
	ofstream outputFile;
	outputFile.open(argv[2]);
	if (!outputFile)
	{
		cout << "Invalid Output File" << endl;
		outputFile.close();
		return 0;
	}
	map<int, string>::iterator itr = Memory.begin();
	for (int i = 0; i < 1024 * 1024; ++i)
	{
		if (i != 0) outputFile<<endl;
		if (itr->first == i)
		{
			outputFile << itr->second;
			if (itr != Memory.end())
			{
				map<int, string>::iterator itrNext = itr;
				++itrNext;
				if (itrNext->first == itr->first)
				{
					cout << "Error, Two instructions in same address" << endl;
					outputFile.close();
					return 0;
				}
				itr = itrNext;
			}
		}
		else outputFile << "00000000000000000000000000000000";
	}
	outputFile.close();
	return 0;
}