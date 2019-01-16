%option noyywrap
%{
#include<string>
#include<vector>
#icnlude "struktury.h"
#include "y.tab.h"

int yyparse();
inline void assign_yylval_vName(char*text);


%}

%%
"PRINT" return PRINT;
"IF" return IF;
"WHILE" return WHILE;


[a-z]+ {
	yylval.vName = new std::string(yytext);
	return VARIABLE;
}
[0-9]+ {
	yylval.iValue = atoi(yytext);
	return VALUE;
	}
"+"|"-"|"*"|"/" {
	yylval.vName=new std::string(yytext);
	return OPERATOR;
	}


";" {
	return yytext[0];
}
"==" {return eq;}
"!=" {return ne;}
">" {return big;}
"<" {return smol;}
">=" {return bieq;}
"<=" {return smeq;}

"=" {return PASS;}

[ \t\n] ;
.	{
	return UNK;
	}
%%