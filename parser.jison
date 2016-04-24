%lex

Symbols               ','|'.'|';'|'('|')'|'{'|'}'|'['|']'
Identifier            [a-zA-Z_]+[a-zA-Z_0-9]*
KeyWords              'namespace'|'import'|'action'|'each'|'to'|'on'|'if'|'where'

%%

\s+                   // ignore
{KeyWords}            return yytext.toLowerCase();
{Identifier}          return 'IDENTIFIER';
{Symbols}             return yytext;
<<EOF>>               return 'EOF';

/lex

%start Root

%%

Root
  : Namespace Instructions EOF
    { return [':ROOT:', $1, $2] }
  ;

Namespace
  : namespace IDENTIFIER ';'
    -> [":NS:", $2]
  |
  ;

Instructions
  : Instructions Instruction
    -> ($1.push($2), $1)
  |
    -> []
  ;

Instruction
  : Action
  | Statement
  ;

Statements
  : Statements Statement
  | 
  ;

Statement
  : ExpressionStatement
  ;

ExpressionStatement
  : Expression ';'
    -> [":ExprSt:", $1]
  ;

Expression
  : IDENTIFIER
  | Expression '.' IDENTIFIER
    -> [":ExprAccess:", $1, $3]
  | Expression '(' ExpressionList ')'
    -> [":ExprCall:", $1, $3]
  | Expression '[' Expression ']'
    -> [":ExprIndex:", $1, $3]
  | '[' ExpressionList ']'
    -> [":List:", $2]
  ;

ExpressionList 
  : ExpressionList ',' Expression
    -> ($1.push($3), $1)
  | Expression
    -> [$1]
  |
    -> []
  ;

Action
  : action IDENTIFIER '(' ParamsList ')' '{' Statements '}'
    -> [":ActionDecl:", $2, $4, $7]
  ;

ParamsList
  : ParamsList ',' IDENTIFIER IDENTIFIER
    -> ($1.push([":Param:", $3, $4]), $1)
  | IDENTIFIER IDENTIFIER
    -> [":Param:", $1, $2]
  | 
    -> []
  ;
