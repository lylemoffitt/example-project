#include "printer_lib/printer.h"

printer::printer(std::ostream & ostr)
: _ostr(ostr)
{
}


void printer::print(std::string str){
    _ostr << str << std::endl;
}