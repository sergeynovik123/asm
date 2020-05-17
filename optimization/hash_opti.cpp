#include <iostream>
#include <fstream>
#include "stdio.h"
#include <array>
#include "string.h"
#include "math.h"
#include <ctime>
#include <assert.h>

const int ARR_SIZE = 1000;
const int N_FUNC = 5;
const int N_WORDS = 10000;


int hash_xor(char*);
int file_size(FILE* name);
char** make_arr_words(FILE* input);


struct node {
	node* next = NULL;
	char* s = {};

	node(char* str) {
		s = str;
	}

};


class list {
private:

	node* head = NULL;
	node* tail = NULL;

public:

	int size = 0;

	int sizeof_list() {
		int size = 0;
		node* this_ = head;

		while (this_) {
			size++;
			this_ = this_->next;
		}
		return size;
	}

	void append(char* str) {
		if (head == NULL) {
			head = new node(str);
			tail = head;
		}
		else {
			node* this_ = head;
			tail->next = new node(str);
			tail = tail->next;
		
		}
		size++;
	}
	/*
	char* find(char* s) {
		if (head == NULL)
			return NULL;
		node* this_ = head;

		while (this_->next != NULL) {
			if (strcmp(this_->s, s) == 0)
				return this_->s;
			else
				this_ = this_->next;
		}
	}
	*/
	
	char* find(char* str) {
		//std::cout << 'a';
		char* ret_str = NULL;
		__asm
		{
			mov esi, str
			mov ebx, head

			next_node : cmp ebx, 0
			je notfound
			mov edi, [ebx + 4]
			call my_strcmp
			cmp eax, 0
			je found
			mov ebx, [ebx]
			jmp next_node

			notfound : mov ret_str, 0
			jmp end_nodes
			found : mov ret_str, edi
			end_nodes :
		}
		return ret_str;
	



		/////////////////////////////////////////////////////////////////////
		//input:	esi - ptr first string
		//			edi - ptr second string
		//output:	eax - ret val(0 - strs equ, <0 - str1 < str2, >0 str1 > str2)
		//destr:	esi, edi, eax
		/////////////////////////////////////////////////////////////////////
		__asm
		{
		my_strcmp:	mov ecx, 0FFFFFFFFh
					cld

		cmp_simb :	cmp[esi], 0
					je str_end
					cmp[edi], 0
					je str_end

					cmpsb
					jne str_end
					jmp cmp_simb
			
					str_end : dec esi
					dec edi

					mov al, [esi]
					sub al, [edi]

					 ret
		}

		
		
	}
	
	
};





extern "C"
{
	int hash_xor(char* str);
}






int main() {
	unsigned int start_time = clock();

	list* arr_lists = new list[ARR_SIZE];

	FILE* input = NULL;
	fopen_s(&input, "C:\\C\\hesh\\hash.txt", "r");
	FILE* output = NULL;
	fopen_s(&output, "C:\\C\\hesh\\hash.csv", "w");

	char** arr_words = make_arr_words(input);



	for (int i = 0; i < N_WORDS; ++i)
		arr_lists[abs(hash_xor(arr_words[i]) % ARR_SIZE)].append(arr_words[i]);
	
	for (int j = 0; j < 7; j++)
		for (int i = 0; i < 10000000; ++i) {
			char* l = arr_lists[abs(hash_xor(arr_words[i % N_WORDS]) % ARR_SIZE)].find(arr_words[i % N_WORDS]);
		}
	
	unsigned int end_time = clock();
	std::cout << end_time - start_time;
}




int file_size(FILE* name) {
	assert(name);

	fseek(name, 0, SEEK_END);
	int size = ftell(name);
	fseek(name, 0, SEEK_SET);

	return size;
}



/*

int hash_xor(char* str) {
	assert(str);
	
	int result = 0;
	int firstbit = 0;

	int i = 0;
	while (str[i] != 0) {
		result ^= str[i];
		firstbit = (result >> 31) & 1;
		result <<= 1;
		result |= firstbit;
		i++;
	}
	return result;

	
}
*/
char** make_arr_words(FILE* input) {
	assert(input);

	int size = file_size(input);
	char* buf = new char[size + 1];
	char* arr_words[N_WORDS] = {};

	fread(buf, 1, size, input);
	char* this_ = buf;
	int j = 0;


	for (int i = 0; i < size; i++) {
		if (buf[i] == '\n') {
			while (buf[i + 1] == '\n')i++;
			buf[i] = 0;
			arr_words[j] = this_;
			++j;
			this_ = buf + i + 1;
			if (j >= N_WORDS)break;
		}
	}

	return arr_words;
}

