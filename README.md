# FlexBison-projekt


Projekt zrealizowany na potrzeby zajęć z przedmiotu JFiK, [PUT Poznań](https://www.put.poznan.pl/en).

## Zadania:
1. Zmodyfikuj podany program tak, aby zmienne mogły mieć nazwy, ktore są dowolnej długości ciągami symboli.
 Zadanie to wykonano w sposób następujący
 * yylval.vName = ~~yytext[0];~~ new std::string(yytext);
 2. Dokonaj zmian, które pozwolą na wykonanie instrukcji po znaku ';'.
 * dodano kontenery odpowiedzialne za przechowywanie informacji o funkcji, zmiennych, oraz o zawartym wyrażeniu,
 * umieszczono instrukcje, odpowiedzialne za odpowiednie umieszczenie procedury w sekwencji wykonywania,
 * dodano metody odpowiedzialne za właściwe wykonywanie programu po analizie linii.
 3. Dodaj instrukcje `IF` oraz `WHILE`
 * Instrukcje wyglądają następująco
	 * `IF` `COND` `FUNCTIONS` gdzie:
		* `COND` = warunek zwracający 
			*	1=>true
			*	0=>false
		* `FUNCTIONS`= wykonywana operacja
	* `WHILE` `VARIABLE` `ASSIGN` `FUNCTIONS`
		* `VARIABLE` = wartość ulegająca zmianie co krok, pętla przerywana gdy = 0
		* `ASSIGN` = operacja redukcji wartości `VARIABLE` z pomocą przypisania,
		* `FUNCTIONS` = operacja wykonywana co krok pętli.

## Semantyka języka
* `LIBRARY` = punkt startowy
* ` FUNCTIONS` = wszystkie możliwe operacje
	* `ASSIGN` = przypisanie zmiennej wartości,
	* `IF` = wyżej opisana instrukcja warunkowa,
	* `WHILE` = wyżej opisana instrukcja pętli,
	* `PRINT` = wyświetlenie wartości `EXP` na ekranie 
* `EXP` = wyrażenie, które może przyjąć postać:
	* `VALUE` = wartości stałej,
	* `VARIABLE` = zmiennej,
	* `OPERATOR` `VALUE`/
`OPERATOR` `VARIABLE` = wyniku operacji na zmiennych, lub zmiennej i wartości.
* `COND` = wartość 0 lub 1 wynikająca z porównania `EXP` `EXP` za pomocą operatorów logicznych
(==,!=,>,<,>=,<=) .

## Kompilacja
Skompilowano na systemie Ubuntu 18_04 bionic beaver.  
Flex v2.6.4  
GNU Bison v3.2.3  
GNU M4 v1.4.18  
g++ v7.3.0  

# Uruchamianie

System Linux: `make` `./output`
System Windows  (testowane przy użyciu [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)):   
`bison -dy grammar.yy`  
`flex lexer.ll`  
`x86_64-w64-mingw32-gc++ lex.yy.c y.tab.c -o output.exe`  
`output.exe`  

## Podziękowania
[RDD](https://rubberduckdebugging.com/cyberduck/)  
[Bisqwit](https://github.com/bisqwit/)  
[SuddenlyPineaple](https://github.com/SuddenlyPineapple)  
[Evenlaxxus](https://github.com/Evenlaxxus)  
