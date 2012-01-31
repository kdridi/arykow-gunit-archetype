grammar Language;

tokens {
  PRINT = 'print';
  DEBUG = 'debug';
}

@lexer::header
{
  package sample;
}

@parser::header
{
  package sample;

  import java.util.HashMap;
}

@parser::members
{
  private static HashMap<String, Integer> variables = new HashMap<String, Integer>();
  private void showVariables() {
    for (String varName : variables.keySet())
      System.out.println(varName + " = " + variables.get(varName).intValue());
    System.out.println("   " + variables.size() + " variable(s)");
  }
}

program
:	statement*
;

statement
:	PRINT expr ';'			{ System.out.println($expr.value); }
|	VARIABLE '=' expr ';'	{ variables.put($VARIABLE.text, new Integer($expr.value)); }
|	DEBUG ';'				{ showVariables(); }
;

expr returns [int value] options { backtrack=true; }
:	e1=exprPri2 { $value = $e1.value; } (
    '+' e2=exprPri2 { $value += $e2.value; }
    |	'-' e2=exprPri2 { $value -= $e2.value; }
    )*
;

exprPri2 returns [int value] options { backtrack=true; }
:	e1=exprPri1 { $value = $e1.value; } (
    '*' e2=exprPri1 { $value *= $e2.value; }
    |	'/' e2=exprPri1 { $value /= $e2.value; }
    )*
;

exprPri1 returns [int value]
:	INTEGER					{ $value = new Integer($INTEGER.text); }
|	VARIABLE				{ $value = variables.get($VARIABLE.text).intValue(); }
|	'(' expr ')'			{ $value = $expr.value; }
|	'-' expr				{ $value = -$expr.value; }
;

VARIABLE
:	LETTER (LETTER | DIGIT)*
;

INTEGER
:	DIGIT+
;

COMMENT
:	'//' (~ NL)* NL? { skip(); }
;

NL
: '\n' | '\r'
;

WS
:	(' ' | '\t' | NL) { skip(); }
;

fragment LETTER
:	'A'..'Z' | 'a'..'z' | '_'
;

fragment DIGIT
:	'0'..'9'
;
