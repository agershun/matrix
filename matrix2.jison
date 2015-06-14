%{ /* JavaScritp code */ %}
%lex
%options case-insensitive
%%

\/\/.*(\n|\n\r)			return
\s 						return
'PRINT'					return 'PRINT'
[0-9]+					return 'NUMBER'
[A-Za-z_][A-Za-z_0-9]*	return 'LITERAL'
'+'						return 'PLUS'
'*'						return 'STAR'
'('						return 'LPAR'
')'						return 'RPAR'
'|'						return 'PALKA'
\'						return 'STRIH'
'='						return 'EQ'
<<EOF>>					return 'EOF'
.						return 'INVALID'

/lex

%start main
%ebnf
%left PLUS
%left STAR
%right STRIH

%%
main
	: Statement* EOF;

Statement
	: (Print|Set) ;

Set 
	: LITERAL EQ Expression;

Print
	: PRINT Expression;

Expression
	: Matrix
	| LITERAL
	| LPAR Expression RPAR
	| Expression PLUS Expression
	| Expression STAR Expression
	| Expression STRIH
	;

Matrix
	: Columns
	;

Row
	: NUMBER
	| Row NUMBER
	;

Columns
	: Row
	| Columns PALKA Row
	;

