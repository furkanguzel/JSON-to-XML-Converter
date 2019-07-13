%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>	
    void yyerror(char *);
    int yylex(void);
    extern FILE *yyin;	
    extern int linenum;
    FILE *out;	
	int t=0;//0 str 1 int 2double 3 truefalse
  
char *gettype(int type){
	switch(type){
		case 0:	return strdup("string");
		case 1: return strdup("integer");
		case 2: return strdup("double");
		case 3: return strdup("boolean");
	}
		 
}
typedef struct node{
	char*name;
	struct node *next;
}node;
node *head;

void check(char* name){
	node *n = malloc(sizeof(node));
	n->name=strdup(name);
	n->next=NULL;
	
node *tmp=head;
	if(head==NULL){ head = n; return;}	
	for( ;tmp->next!=NULL;tmp=tmp->next){
		if(!strcmp(tmp->name,name)) yyerror("variable name");
	}

		if(!strcmp(tmp->name,name)) yyerror("variable name");
	tmp->next=n;
}


%}
%union
{
char *string;
}
%token PLUSOP ASSIGNOP OPB CMM CLB OPENBRACES CLOSEBRACES COLON MINUS PLUS NAIL DOT CHARR
%token <string>  VAR NUM TR FLS INT DOUBLE
%type  <string> arr elements body val  x OPENBRACES CLOSEBRACES

%%

program:
      OPENBRACES {printf("%s\n","<object1>",$1);fprintf(out,"%s\n","<object1>",$1);} body CLOSEBRACES {printf("%s\n","<object1>",$3);fprintf(out,"%s\n","<object1>",$3);} 
      |
      OPENBRACES CLOSEBRACES{/*burayı unutma*/}
      ; 	 	
body: 
     VAR COLON val CMM  {char *x= strndup(++$1,strlen($1)-2);check(x);printf("    <%s>%s</%s>\n",x,$3,x);fprintf(out,"    <%s>%s</%s>\n",x,$3,x);} body
     |     
     VAR COLON val {char *x= strndup(++$1,strlen($1)-2);check(x);printf("    <%s>%s</%s>\n",x,$3,x);fprintf(out,"    <%s>%s</%s>\n",x,$3,x);}
      ;
	
val: 
     arr 
     |
     body 
     |
     TR {t=3;} 
     |
     FLS {t=3;}
     |
     x	
     ;

x:VAR x{t=0;}
  |
  VAR {t=0;$$=strndup(++$1,strlen($1)-2);}
  |
  INT x{t=1;}
  |
  INT {t=1;}
  | 
  DOUBLE x{t=2;}
  |
  DOUBLE {t=2;}

  ;


arr: OPB elements CLB {$$=$2;}
     	 	;
elements: elements CMM val {sprintf($$,"%s     <%s>%s</%s>\n",$1,gettype(t),$3,gettype(t));}
	  |
          val {char *v=strdup($1);sprintf($$,"\n     <%s>%s</%s>\n",gettype(t),v,gettype(t));}
	;
%%

void yyerror(char *s){
	fprintf(stderr,"error: %s\n",s);
	printf("mistake no :%d",linenum);
exit(1);
}
int yywrap(){
	return 1;
}

int main(int argc, char *argv[])
{

    yyin=fopen(argv[1],"r");
    out = fopen("xml.txt","w");
    		
    yyparse();
    fclose(yyin);
    fclose(out);
    return 0;

}
