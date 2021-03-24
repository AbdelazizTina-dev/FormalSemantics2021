%option noyywrap c++ yylineno

%{
#include "Parserbase.h"
%}

%%

muffin          return Parser::MUFFIN;
sandwich        return Parser::SANDWICH;
burger          return Parser::BURGER;
cake            return Parser::CAKE;

muffins         return Parser::MUFFINS;
sandwiches      return Parser::SANDWICHES;
burgers         return Parser::BURGERS;
cakes           return Parser::CAKES;

a|one           return Parser::ONE;
two             return Parser::TWO;
three           return Parser::THREE;
dozen           return Parser::DOZEN;

light           return Parser::LIGHT;
then|plus|and|, return Parser::PLUS;

[ \t\r\n]       /* dropping whitespaces */

.           {
                std::cerr << lineno() << ": Lexical error." << std::endl;
                exit(1);
            }
