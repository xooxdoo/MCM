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
  : Imports Namespace Instructions EOF
    { return {type:'ROOT', imports: $1, namespace:$2, body:$3 } }
  ;

Namespace
  : namespace IDENTIFIER ';'
    -> { type:'Namespace', namespace:$2 }
  |
  ;

Imports
  : Imports Import
    -> ($1.push($2), $1)
  |
    -> []
  ;

Import
  : import QualifiedName ';'
    -> { type:'Import', qualifiedName:$2 }
  ;

QualifiedName
  : IDENTIFIER
    -> [$1]
  | QualifiedName '.' IDENTIFIER
    -> ($1.push($3), $1)
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
    -> ($1.push($2), $1)
  |
    -> []
  ;

Statement
  : ExpressionStatement
  ;

ExpressionStatement
  : Expression ';'
    -> { type: "ExpressionStatement", expression: $1 }
  ;

Expression
  : IDENTIFIER
    -> { type: "IdentifierExpression", identifier: $1 }
  | Expression '.' IDENTIFIER
    -> { type: "AccessExpression", expression: $1, identifier: $3 }
  | Expression '(' ExpressionList ')'
    -> { type: "CallExpression", expression: $1, arguments: $3 }
  | Expression '[' ExpressionList ']'
    -> { type: "IndexExpression", expression: $1, indexes: $3 }
  | '[' ExpressionList ']'
    -> { type: "List", content: $2 }
  ;

ExpressionList 
  : FilledExpressionList
  |
    -> []
  ;

FilledExpressionList
  : FilledExpressionList ',' Expression
    -> ($1.push($3), $1)
  | Expression
    -> [$1]
  ;

Action
  : action IDENTIFIER '(' ParamsList ')' '{' Statements '}'
    -> { type: "ActionDeclaration", identifier: $2, params: $4, body: $7 }
  ;

ParamsList
  : FilledParmsList
  | 
    -> []
  ;

FilledParmsList
  : FilledParmsList ',' IDENTIFIER IDENTIFIER
    -> ($1.push({ type: "Param", predicate: $3, identifier: $4 }), $1)
  | IDENTIFIER IDENTIFIER
    -> [{ type: "Param", predicate: $1, identifier: $2 }]
  ;
