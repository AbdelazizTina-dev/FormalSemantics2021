%baseclass-preinclude "semantics.h"
%lsp-needed

%token ONE TWO THREE DOZEN
%token BURGER SANDWICH MUFFIN CAKE
%left PLUS

%union {
    food* food_info;
    int amount;
}

%type<food_info> food;
%type<amount> amount;

%%

start:
    food
    {
        if($1->gluten)
        	std::cerr << "Beware! The food contains gluten." << std::endl;
        if($1->calories > 2000) {
            std::cerr << "That's a lot of calories, you cannot eat that much!" << std::endl;
            error();
        }
        if($1->type == sweet) {
            std::cout << "OK, that's gonna be " << $1->calories << " sweet calories!" << std::endl;
        }
        else if($1->type == salty) {
            std::cout << "OK, that's gonna be " << $1->calories << " salty calories!" << std::endl;
        }
        else {
            std::cout << "OK, that's gonna be " << $1->calories << " balanced calories!" << std::endl;
        }
    }
;

food:
    amount BURGER
    {
        $$ = new food($1*500, salty, true);
    }
|
    amount SANDWICH
    {
        $$ = new food($1*200, salty, false);
    }
|
    amount MUFFIN
    {
        $$ = new food($1*100, sweet, true);
    }
|
    amount CAKE
    {
    	if($1 > 1)
    	{
            std::cerr << "Sorry, but you cannot eat more than one cake at once." << std::endl;
            error();
    	}
        $$ = new food($1*500, sweet, false);
    }
|
    food PLUS food
    {
        if(($1->type == sweet || $1->type == mixed) && $3->type == salty) {
            std::cerr << "Really? No, you should not eat salty after the sweet..." << std::endl;
            error();
        }
        if($1->type == $3->type) {
            $$ = new food($1->calories + $3->calories, $1->type, $1->gluten || $3->gluten);
        }
        else {
            $$ = new food($1->calories + $3->calories, mixed, $1->gluten || $3->gluten);
        }
    }
;

amount:
    ONE     { $$ = 1; }
|
    TWO     { $$ = 2; }
|
    THREE   { $$ = 3; }
|
    DOZEN   { $$ = 12; }
;
