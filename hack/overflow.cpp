#include <stdio.h>
#include <iostream>
#include <assert.h>

const int RET_ADDR = 0xFFFC;
const int BUF_ADDR = 0x0166;
const int truehash = 7087220;

bool hash_file(FILE* prog);
	

int main(){

	FILE* prog = fopen("W:\\TOBEHACK.com", "r");
	assert(prog);
	if(!check_hash_file(prog))
		return 0;

	FILE* output = fopen("W:\\hack.txt", "w");
	assert(output);
	int dif = RET_ADDR - BUF_ADDR + 3;

	char buf = new char[dif];
	buf[dif - 3] = 0x14;	
	buf[dif - 2] = 0x01;	
	buf[dif - 1] = '\r';	
	
	fwrite(buf, 1, dif, output);
	printf("All done\n");

	fclose(output); 
}

bool hash_file(FILE* prog){
	assert(prog);

	fseek(prog, 0, SEEK_END);
	int file_size = ftell(prog);
	fseek(prog, 0, SEEK_SET);
	
	char* buff = new char[file_size];
	fread(buff, sizeof(char), file_size, prog);

	int hash = 0;
	for(int i = 0; i < file_size; ++i)
		hash += buff[i] * i * 31;
	
	if(hash != truehash){
		printf("WRONG FILE");
		return false;
	}
	return true;
}
