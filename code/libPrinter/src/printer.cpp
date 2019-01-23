#include "printer_lib/printer.h"

#ifndef APPEND_ENDLINE
#define APPEND_ENDLINE 1
#endif

Printer::Printer(std::ostream & ostr)
: _ostr(ostr)
{
}


void Printer::print(std::string str){
    _ostr 
        << str
#if APPEND_ENDLINE 
        << std::endl
#endif
    ;
}