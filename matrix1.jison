%{ /* JavaScritp code */ %}
%lex
%options case-insensitive
%%

\/\/.*$					return
\s 						return
'PRINT'					return 'PRINT'
[0-9]+					return 'NUMBER'
[A-Za-z_][A-Za-z_0-9]*	return 'LITERAL'
'+'						return 'PLUS'
'*'						return 'STAR'
'('						return 'LPAR'
')'						return 'RPAR'
\'						return 'STRIH'
'='						return 'EQ'
';'						return 'SEMICOLON'
<<EOF>>					return 'EOF'
.						return 'INVALID'

/lex
%start main
%ebnf
%%
main:;
/* Grammar rules */
