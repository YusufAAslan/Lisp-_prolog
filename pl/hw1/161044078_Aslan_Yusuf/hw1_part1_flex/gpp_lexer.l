%{ //defination area
	#include <ctype.h>
	#include <string.h>
	#include <stdlib.h>
	#include <stdio.h>
	
	int i = 0,k = 0;
%} 

%% //rules area
"\"" {
static int  temp = 0;//used to keep track of open curley brace and close curley brace tracking
if(temp == 0){printf("OP_OC\n"); temp = 1;}else{printf("OP_CC\n");temp = 0;}}

and|or|not|equal|less|nil|list|append|concat|set|deffun|for|if|exit|load|disp|true|false {  //keywords 

int iterator = 0;
while(yytext[iterator ]){ yytext[iterator] = (toupper(yytext[iterator])); iterator++;}
printf("KW_%s\n",yytext);}

"+" {printf("OP_PLUS\n");}//operators
"-" {printf("OP_MINUS\n");}
"/" {printf("OP_DIV\n");}
"*" {printf("OP_MULT\n");}
"(" {printf("OP_OP\n");}
")" {printf("OP_CP\n");}
"**" {printf("OP_DBLMULT\n");}

"," {printf("OP_COMMA\n");}

"0" {printf("VALUE\n");}

[-]*[1-9]*[0-9]+ {printf("VALUE\n");}

[a-zA-Z_][a-zA-Z0-9_]* {printf("IDENTIFIER\n");}

[ \t\n]+ // ignores white spaces

";;".*$ {printf("COMMENT\n");}//detects comments

"(exit)".*$ {exit(0); }
%% 

// code segment >>>>
int yywrap(){} 

void gpp_interpreter(){
	
	FILE *fp;
	char *filename,*oneLine,*st;
	
	filename = (char*) malloc(sizeof(char));
	st = (char*) malloc(sizeof(char));


	scanf("%c",&st[i]);//get the command if the interprter takes the code from terminal of from file. 
	
	while(st[i] !='\n'){
		if(st[i] != ' ' && st[i] != '$' && st[i] != 'g' && st[i] != '+'){
			filename[k] = st[i];
			k++;
		}
		i++;
		scanf("%c",&st[i]);
	}
	if(st[4] =='\n'){//if interpreter takes inpur from terminal
		
		printf("> ");
		yylex();
		free(oneLine);
	}
	else{//input from .txt files
		
		printf(">\n");
		fp = fopen(filename,"r");
		yyin = fp;
		yylex();
		free(filename);
	}
	
	free(st);
	fclose(fp);
}
int main(){ 

	gpp_interpreter();
	return 0; 
}
