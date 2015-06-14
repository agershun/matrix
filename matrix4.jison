%{ 

var MATRIX = {
	fn : {},  // Storage for functions
	mem : {}, // Memory for variables

	// Print matrix
	print: function (m) {
		console.log(m.map(function(row){
			return row.join('\t');
		}).join('\n'));
	},

	// Add two matrices
	add: function (a,b) {
		if(a.length == 1 && a[0].length == 1) {
			var t = b; b = a; a = t;
		}
		var c = [];
		for(var i=0;i<a.length;i++) {
			c[i] = [];
			for(var j=0;j<a[i].length;j++) {
				c[i][j] = a[i][j];
				if(b.length == 1 && b[0].length == 1) {
					c[i][j] += b[0][0];
				}
			}
		}
		return c;
	},

	// Multiply two matrices
	multiply: function (a,b) {
		if(a.length == 1 && a[0].length == 1) {
			var t = b; b = a; a = t;
		}
		var c = [];
		if(b.length == 1 && b[0].length == 1) {
			for(var i=0;i<a.length;i++) {
				c[i] = [];
				for(var j=0;j<a[0].length;j++) {
					c[i][j] = a[i][j]*b[0][0];
				}
			}
		} else {
			for(var i=0;i<a.length;i++) {
				c[i] = [];
				for(var j=0;j<b[0].length;j++) {
					c[i][j] = 0;
					for(var k=0;k<b.length;k++) {
						c[i][j] += a[i][k]*b[k][j];
					}
				}
			}
		}
		return c;	
	},

	// Transpose matrix
	transpose: function (a) {
		var c = [];
		for(var i=0;i<a[0].length;i++) {
			c[i] = [];
			for(var j=0;j<a.length;j++) {
				c[i][j] = a[j][i];
			}
		}
		return c;
	}
};

MATRIX.fn.size = function (a) {
	return [[a.length, a[0].length]];
};


%}
%lex
%options case-insensitive
%%

\/\/.*(\n|\n\r)			return
\s 						return
'PRINT'					return 'PRINT'
[0-9]+(\.[0-9]*)?		return 'NUMBER'
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
	: Statement* EOF
		{ return new Function('var MATRIX = this;'+$1.join(';')).bind(MATRIX); }
	;

Statement
	: Print
		{ $$ = $1; }
	| Set 
		{ $$ = $1; }
	;

Print
	: PRINT Expression
		{ $$ = 'MATRIX.print('+$2+')'; }
	;

Set 
	: LITERAL EQ Expression
		{ $$ = 'MATRIX.mem["'+$1+'"]='+$3; }
	;

Expression
	: Matrix
		{ $$ = $1; }
	| LITERAL
		{ $$ = 'MATRIX.mem["'+$1+'"]'; }
	| LPAR Expression RPAR
		{ $$ = $1; }
	| Expression PLUS Expression
		{ $$ = 'MATRIX.add('+$1+','+$3+')'; }
	| Expression STAR Expression
		{ $$ = 'MATRIX.multiply('+$1+','+$3+')'; }
	| Expression STRIH
		{ $$ = 'MATRIX.transpose('+$1+','+$2+')'; }
	| LITERAL LPAR Expression RPAR
		{ $$ = 'MATRIX.fn["'+$1+'"]('+$3+')'; }
	;

Matrix
	: Columns
		{ $$ = '['+$1.map(function(r){return '['+r.join(',')+']'})+']'; }
	;

Row
	: NUMBER
		{ $$ = [parseFloat($1)]; }
	| Row NUMBER
		{ $$ = $1; $$.push(parseFloat($2)); }
	;

Columns
	: Row
		{ $$ = [$1]; }
	| Columns PALKA Row
		{ $$ = $1; $$.push($3); }
	;

