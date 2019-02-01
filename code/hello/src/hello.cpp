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
        ("help,h", "print usage message")
        ("version,v", "print version string")
    ;

    po::variables_map vm;
    try {
        po::store(parse_command_line(argc, argv, desc), vm);
        po::notify(vm);
        
        printer::Printer printer(std::cout);
        if (vm.count("help")) {
            printer.print(usage());
            return 0;
        }
        if (vm.count("version")){
            using p_vs = version::project;
            using g_vs = version::git;
            auto dirty_str = [](bool dirty)->std::string {
                return dirty ? "dirty" : "clean";
            };
            std::cout 
                << p_vs::name() << " v" << p_vs::semver()
                << "\n\t" 
                << "from: " 
                << g_vs::url() << " @ " << g_vs::hash() << "-" << dirty_str(g_vs::dirty)
                << std::endl;
            return 0;
        }

        printer.print(greeting + greeted);
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