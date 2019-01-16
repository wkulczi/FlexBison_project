%{
    #include<map>
    #include<stack>
    #include<vector>
    #include<iostream>
    #include "struktury.h"
    int yylex();
    void yyerror(std::string msg);
    std::map<std::string, int> vars_map;
    std::map<std::string, int> order = {{"",0},{"+",0},{"-",0},{"*",1},{"/",1}};
    inline int run(std::vector<function>&fun, int &i);
    inline int calculate_exp(const std::vector<expression_struct>&exp);
    inline int calc(int &l, const std::string &o, int &r);
  
    
    
%}

%union {
    int iValue;
    std::string* vName;
    std::vector<expression_struct>* expressions;
    std::vector<function>* functions;
}

%token eq ne big smol bieq smeq PASS 

%start LIBRARY
%token WHILE IF UNK PRINT VARIABLE
%token <iValue> VALUE
%type <vName> VARIABLE
%type <functions> FUNCTIONS
%type <expressions> EXP
%type <iValue> COND
%type <functions> ASSIGN
%token <vName> OPERATOR


%%
LIBRARY : LIBRARY FUNCTIONS ';' {
			for(int i = 0; i < $2->size(); i++){
                run(*$2, i);
			}
		}
        | LIBRARY FUNCTIONS {}
        | %empty
		;

FUNCTIONS : PRINT EXP { $$ = new std::vector<function>{function(F_type::print, *$2)}; }
			| ASSIGN { $$ = $1; }
			| IF COND FUNCTIONS {
				$$ = $3;
				$$->insert($$->begin(), function(F_type::_if, std::vector<expression_struct>{expression_struct($2)}));
			}
			| WHILE VARIABLE ASSIGN FUNCTIONS {
				$$ = $4;
				$$->insert($$->begin(), $3->begin(), $3->end());
				function temp;
				temp.ftype= F_type::_while;
				temp.variable = *$2;
				$$->insert($$->begin(), temp);
			}
			;

ASSIGN : VARIABLE PASS EXP { $$ = new std::vector<function>{function(F_type::assign, *$3, *$1)};}

EXP : VALUE {$$ = new std::vector<expression_struct>{expression_struct($1)};}
	| VARIABLE { if(vars_map.find((*$1)) == vars_map.end()) yyerror(("Variable " + (*$1) + " undeclared").c_str() );
		$$ = new std::vector<expression_struct>{expression_struct(*$1)};
		}
	| EXP OPERATOR VALUE {
		($$->back()).operation = *$2;
		$$->emplace_back(expression_struct($3));
	}
	| EXP OPERATOR VARIABLE {
		($$->back()).operation = *$2;
		$$->emplace_back(expression_struct(*$3));
	}
	;

COND 	: EXP { 
				int a = calculate_exp(*$1);
				a != 0 ? $$ = 1 : $$ = 0;
			}
            | EXP eq EXP {int a= calculate_exp(*$1); int b=calculate_exp(*$3); a==b? $$=1 : $$=0;}
            | EXP ne EXP {int a= calculate_exp(*$1); int b=calculate_exp(*$3); a!=b? $$=1 : $$=0;}
            | EXP big EXP  {int a= calculate_exp(*$1); int b=calculate_exp(*$3); a>b? $$=1 : $$=0;}
            | EXP smol EXP  {int a= calculate_exp(*$1); int b=calculate_exp(*$3); a<b? $$=1 : $$=0;}
            | EXP bieq EXP {int a= calculate_exp(*$1); int b=calculate_exp(*$3); a>=b? $$=1 : $$=0;}
            | EXP smeq EXP {int a= calculate_exp(*$1); int b=calculate_exp(*$3); a<=b? $$=1 : $$=0;}
			;

%%

int calc(int &l, const std::string &o, int &r)
    {
        if(o=="/") l/=r;
        else if (o=="*") l*=r;
        else if (o=="-") l-=r;
        else if (o=="+") l+=r;
    }

int calculate_exp(const std::vector<expression_struct>&exp)
{
    int res,temp1,temp2;

    std::stack<expression_struct> mem;
    exp[0].variable == "" ? res = exp[0].value : res = vars_map[exp[0].variable]; 
    if (exp.size()<2) return res;
    for(int i = 0; i < exp.size() - 1; i++)
    {
        exp[i+1].variable == "" ? temp2 = exp[i+1].value : temp2 = vars_map[exp[i+1].variable]; 

        if( order.at(exp[i].operation) >= order.at(exp[i+1].operation) ) {
            mem.empty() ? calc(res, exp[i].operation, temp2) : calc(temp1, exp[i].operation, temp2);
        } else {
            temp1 = temp2; 
            mem.emplace(exp[i]);
        }

        while(!mem.empty()){
            if( order.at(mem.top().operation) >= order.at(exp[i + 1].operation) ) {
                if( mem.size() > 1 ) { 
                    mem.top().variable == "" ? temp2 = mem.top().value : temp2 = vars_map[mem.top().variable];      
                    calc(temp1, mem.top().operation, temp2);
                } else 
                    calc(res, mem.top().operation, temp1);

                mem.pop();
                if(mem.empty()) temp1 = 0;
            }
            else break;
    }
    }
return res;
}

int run(std::vector<function>&fun, int &i)
{
    function &temp=fun[i];
    switch(temp.ftype)
    {
        case F_type::assign:
        {
            vars_map[temp.variable]=calculate_exp(temp.ex_vec);
            std::cout << "Variable " << temp.variable << " = " << vars_map[temp.variable] << "\n";
            break;
        }
        case F_type::print:
        {
            std::cout << calculate_exp(temp.ex_vec) << "\n";
            break;
        }
        case F_type::_if:
        {
            if (temp.ex_vec[0].value==0) i++;
            break;
        }
        case F_type::_while:
        {
            const std::string fun_var= temp.variable;
            i+=2;
            while(vars_map[fun_var]!=0)
            {
                int a=2;
                int c=1;

                run(fun,a);
                run(fun,c);
            }
            break;
        }

    }
    return 0;
}

int main(){
	yyparse();
	return 0;
}

void yyerror(std::string msg){
	std::cerr << "Error: " << msg << "!\n";
}

