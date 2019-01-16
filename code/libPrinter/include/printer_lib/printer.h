#ifndef PRINTER_LIBRARY_H_
#define PRINTER_LIBRARY_H_

#include <ostream>
#include <string>


class printer{
    std::ostream & _ostr;

public:
    printer(std::ostream & ostr);

    void print(std::string str);
};

#endif  // PRINTER_LIBRARY_H_
