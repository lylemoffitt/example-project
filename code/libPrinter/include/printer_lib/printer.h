#ifndef PRINTER_H_
#define PRINTER_H_

#include <ostream>
#include <string>

#include <printer_lib/version.h>

namespace printer {

class Printer{
    std::ostream & _ostr;

public:
    Printer(std::ostream & ostr);

    void print(std::string str);
};

}

#endif  // PRINTER_H_
