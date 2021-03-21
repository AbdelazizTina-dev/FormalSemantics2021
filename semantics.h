#ifndef SEMANTICS_H
#define SEMANTICS_H
#include<iostream>
#include<stdlib.h>

enum food_type { salty, sweet, mixed };

struct food {
    int calories;
    food_type type;
    bool gluten;
    food() {}
    food(int c, food_type t, bool g) : calories(c), type(t), gluten(g) {}
};

#endif
