%baseclass-preinclude "semantics.h"
%lsp-needed

%token ONE TWO THREE DOZEN
%token BURGER SANDWICH MUFFIN CAKE
%token BURGERS SANDWICHES MUFFINS CAKES
%token LIGHT
%left PLUS

%union {
    food* food_info;
    int amount;
}

%type<food_info> food;
%type<amount> amount;

/*
	        Caloris	    Sugar	  Light Cals	Light Sugar
Cake        500         20        250           10
Muffin      100		    10         50           5
Sandwich    200          5        100           2
Burger      500		     5	      250           2
*/

%%

start:
    food
    {
        if($1->sugar > 50){
        	std::cerr << "Sugar content (" << $1->sugar <<" g) exceeds the 50g limit" << std::endl;
            error();
        }
        if($1->gluten)
        	std::cerr << "Beware! The food contains gluten." << std::endl;
        if($1->calories > 2000) {
            std::cerr << "That's a lot of calories, you cannot eat that much!" << std::endl;
            error();
        }
        if($1->type == sweet) {
            std::cout << "OK, that's gonna be " << $1->calories << " sweet calories! Total sugar amount: " << $1->sugar << "g" <<std::endl;
        }
        else if($1->type == salty) {
            std::cout << "OK, that's gonna be " << $1->calories << " salty calories! Total sugar amount: " << $1->sugar << "g" << std::endl;
        }
        else {
            std::cout << "OK, that's gonna be " << $1->calories << " balanced calories! Total sugar amount: " << $1->sugar << "g" << std::endl;
        }
    }
;

food:

    amount LIGHT BURGERS
    {
        if ($1 < 2) 
            error();
        $$ = new food($1*250, $1*2,salty, true);
    }
|
    amount LIGHT SANDWICHES
    {
        if ($1 < 2) 
            error();
        $$ = new food($1*100, $1*2,salty, false);
    }
|
    amount LIGHT MUFFINS
    {
        if ($1 < 2) 
            error();
        $$ = new food($1*50, $1*5,sweet, true);
    }
|
    amount LIGHT CAKES
    {
        if ($1 == 1) 
            error();
        if($1 > 2)
    	{
            std::cerr << "Sorry, but you cannot eat more than two light cakes at once." << std::endl;
            error();
    	}
        $$ = new food($1*250, $1*10,sweet, false);
    }
|
    amount BURGERS
    {
        if ($1 < 2) 
            error();
        $$ = new food($1*500, $1*5,salty, true);
    }
|
    amount SANDWICHES
    {
        if ($1 < 2) 
            error();
        $$ = new food($1*200, $1*5,salty, false);
    }
|
    amount MUFFINS
    {
        if ($1 < 2) 
            error();
        $$ = new food($1*100, $1*10,sweet, true);
    }
|
    amount CAKES
    {
    	if($1 == 1)
    	{
            error();
    	}
        if ($1 >= 2)    	
        {
            std::cerr << "Sorry, but you cannot eat more than one cake at once." << std::endl;
            error();
    	}

        $$ = new food($1*500, $1*20,sweet, false);
    }
|

    amount LIGHT BURGER
    {
        $$ = new food($1*250, $1*2,salty, true);
    }
|
    amount LIGHT SANDWICH
    {
        $$ = new food($1*100, $1*2,salty, false);
    }
|
    amount LIGHT MUFFIN
    {
        $$ = new food($1*50, $1*5,sweet, true);
    }
|
    amount LIGHT CAKE
    {
        if($1 > 2)
    	{
            std::cerr << "Sorry, but you cannot eat more than two light cakes at once." << std::endl;
            error();
    	}
        $$ = new food($1*250, $1*10,sweet, false);
    }
|
    amount BURGER
    {
        if ($1 > 1)
            error();
        $$ = new food($1*500, $1*5,salty, true);
    }
|
    amount SANDWICH
    {
        if ($1 > 1)
            error();
        $$ = new food($1*200, $1*5,salty, false);
    }
|
    amount MUFFIN
    {
        if ($1 > 1)
            error();
        $$ = new food($1*100,$1*10,sweet, true);
    }
|
    amount CAKE
    {
        /*since there is only one possibilty that works with "one cake | a cake" I removed
        the more than one cake warning since it's the same as my gramatical error, for ex: "two cake"*/
    	if($1 > 1)
    	{
            error();
    	}
        $$ = new food($1*500,$1*20,sweet,false);
    }
|
    food PLUS food
    {
        if(($1->type == sweet || $1->type == mixed) && $3->type == salty) {
            std::cerr << "Really? No, you should not eat salty after the sweet..." << std::endl;
            error();
        }
        if($1->type == $3->type) {
            $$ = new food($1->calories + $3->calories, $1->sugar + $3->sugar, $1->type, $1->gluten || $3->gluten);
        }
        else {
            $$ = new food($1->calories + $3->calories, $1->sugar + $3->sugar, mixed, $1->gluten || $3->gluten);
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