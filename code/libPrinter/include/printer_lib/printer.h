#ifndef PRINTER_LIBRARY_H_
#define PRINTER_LIBRARY_H_

#include <ostream>
#include <string>


class Printer{
    std::ostream & _ostr;

public:
    Printer(std::ostream & ostr);

    void print(std::string str);
};

#endif  // PRINTER_LIBRARY_H_
