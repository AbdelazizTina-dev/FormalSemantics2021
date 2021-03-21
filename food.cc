#include <iostream>
#include <fstream>
#include <string>
#include <FlexLexer.h>
#include <cstdlib>
#include "Parser.h"

using namespace std;

void input_handler( ifstream& in, int argc, char* argv[] );

int main( int argc, char* argv[] )
{
    ifstream in;
    input_handler(in, argc, argv);
    Parser parser(in);
    parser.parse();
    return 0;
}

void input_handler( ifstream& in, int argc, char* argv[] )
{
    if( argc < 2 )
    {
        cerr << "Please specify a file in the first argument." << endl;
        exit(1);
    }
    in.open( argv[1] );
    if( !in )
    {
        cerr << "Couldn't open " << argv[1] << "." << endl;
        exit(1);
    }
}

