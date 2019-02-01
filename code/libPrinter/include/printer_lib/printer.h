#ifndef PRINTER_H_
#define PRINTER_H_

#include <ostream>
#include <string>

#include <printer_lib/version_api.h>


namespace printer {




// struct version{
//     static project_version project;
//     static git_version git;
// };
// using project_version = project_version;
// using git_version = git_version;

class Printer{
    std::ostream & _ostr;

public:
    Printer(std::ostream & ostr);

    void print(std::string str);
};

}

#endif  // PRINTER_H_
