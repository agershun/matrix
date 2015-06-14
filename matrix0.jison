%{ /* JavaScritp code */ %}
%lex
%options case-insensitive
%%
/* Lexems */
.	return 'INVALID'
/lex
/* Priorities rules */
%start main
%%
main:;
/* Grammar rules */
