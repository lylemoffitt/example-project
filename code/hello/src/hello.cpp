#include "hello.h"
#include <printer_lib/printer.h>

#include <iostream>
#include <string>

#include <boost/program_options.hpp>
namespace po =  boost::program_options;

#ifndef HELLO_STRING
#define HELLO_STRING "hello"
#endif

std::string usage() {
    std::string ret("usage: ");
    ret += "\t hello [thing]";
    return ret;
}

int main(int argc, char** argv) {
    std::string greeting( HELLO_STRING );
    std::string greeted( argc>1 ? argv[1] : "you");

    po::options_description desc("Allowed options");
    desc.add_options()
        ("help,h", "print usage message");

    po::variables_map vm;
    try {
        store(parse_command_line(argc, argv, desc), vm);

        Printer printer(std::cout);
        if (vm.count("help")) {
            printer.print(usage());
            return 0;
        } else {
            
            printer.print(greeting + greeted);
        }
    } catch (po::error& e) {
        std::cerr 
            << "ERROR: " 
            << e.what() 
            << std::endl 
            << std::endl;
        std::cerr << desc << std::endl;
        return 1;
    } catch(std::exception& e) 
    { 
        std::cerr 
            << "Unhandled Exception: "  
            << e.what() 
            << std::endl; 
        return 2; 
    } 

    return 0;
}