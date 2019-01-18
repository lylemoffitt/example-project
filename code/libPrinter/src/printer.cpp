#include "printer_lib/printer.h"

Printer::Printer(std::ostream & ostr)
: _ostr(ostr)
{
}


void Printer::print(std::string str){
    _ostr << str << std::endl;
}