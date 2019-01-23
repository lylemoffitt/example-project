cmake_minimum_required(VERSION 3.5)

project(Hello
    VERSION 1.0.0 
    LANGUAGES CXX
)


message("CMAKE_MODULE_PATH          : " ${CMAKE_MODULE_PATH})
message("CMAKE_PREFIX_PATH          : " ${CMAKE_PREFIX_PATH})
message("CMAKE_INSTALL_PREFIX       : " ${CMAKE_INSTALL_PREFIX})
message("CMAKE_SOURCE_DIR           : " ${CMAKE_SOURCE_DIR})
message("CMAKE_BINARY_DIR           : " ${CMAKE_BINARY_DIR})
message("CMAKE_CURRENT_SOURCE_DIR   : " ${CMAKE_CURRENT_SOURCE_DIR})
message("PROJECT_BINARY_DIR         : " ${PROJECT_BINARY_DIR})
message("PROJECT_SOURCE_DIR         : " ${PROJECT_SOURCE_DIR})


# Configuration options for this project
#   - These options will be exposed in ccmake or cmake-gui
#   - Strings are stored unquoted
set(opt_${PROJECT_NAME}_greet_string
    "hello" # Defualt value
    CACHE STRING
    "String to use as greeeting."
)

# Put together list of all source file
file(GLOB src_files
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/**/*.cpp
)

# Create executable target
add_executable(${PROJECT_NAME} ${src_files})

# Set target include directories
#   - headers will be discoved through includes
target_include_directories(${PROJECT_NAME}

    # Properties that are exposed to the consumer. 
    #   - Available under the INTERFACE_ prefix
    #   - Populates INTERFACE_INCLUDE_DIRECTORIES
    INTERFACE

    # Properties that are both exposed and hidden.
    #   - Available under the PUBLIC_ prefix
    #   - Populates INCLUDE_DIRECTORIES
    #   - Populates INTERFACE_INCLUDE_DIRECTORIES
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        
    # Properties that are hidden from the consumer.
    #   - Available under the PRIVATE_ prefix
    #   - Populates INCLUDE_DIRECTORIES
    PRIVATE
        # ${CMAKE_CURRENT_SOURCE_DIR}/src
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
        # $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

# Set compiler options for this target
target_compile_options(${PROJECT_NAME} 
    # Compilation options passed on to consumers
    PUBLIC
    # Compilation options for this target only
    PRIVATE
        # Always use the flags
        -Werror
        # Use these flags when compiling in debug mode
        $<$<CONFIG:DEBUG>: 
            -O0 -g3 -ggdb 
        >
        # Use these flags when compiling in release mode
        $<$<CONFIG:RELEASE>:
            -O2 
        >
)

# Set compiler features required by this target
#   - Implicitly defines compiler version based on feature support
# https://cmake.org/cmake/help/v3.1/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html
target_compile_features(${PROJECT_NAME} 
    PRIVATE 
        # cxx_std_11 # req. cmake v3.8
)

# Set compiler properties for this target
#   - Explicitly set compiler version and other properties
# https://cmake.org/cmake/help/v3.4/manual/cmake-properties.7.html#target-properties
set_target_properties(${PROJECT_NAME} 
    PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED YES
        CXX_EXTENSIONS NO
)

# Define veriable for the target compilation
target_compile_definitions(${PROJECT_NAME}
    PRIVATE
        # Pass configuration options to compiler
        #   - Must quote to preserve string
        HELLO_STRING="${opt_${PROJECT_NAME}_greet_string}"
) 

# Set compiler features required by this target
# https://cmake.org/cmake/help/v3.1/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html
target_compile_features(${PROJECT_NAME} 
    PRIVATE 
        # cxx_std_11  # req. cmake v3.8
    )

# Package must be found before it can be linked
#   - Execute FindBoost.cmake to get Boost::program_options
find_package(Boost 1.55 REQUIRED COMPONENTS program_options)

#   - Execute FindPrinter.cmake to get Printer::Printer
find_package(Printer QUIET COMPONENTS Printer)

# Directly build the subdirectory if it hasn't been found
if(Printer_FOUND)
    message(STATUS 
        "libPrinter FOUND: successful find_package")
else()
    message(STATUS 
        "libPrinter NOT FOUND: reverting to add_subdirectory")
    add_subdirectory(deps/libPrinter code/libPrinter) 
endif()


# Set target links
target_link_libraries(${PROJECT_NAME} 
    
    # Targets links to expose to callers
    PUBLIC
        # Target with interface exposed in header
    
    # Targets to link against privately
    PRIVATE
        Boost::program_options
        Printer::Printer
)

# Add target to the list of exports for the module
install(TARGETS ${PROJECT_NAME}
    
    # Install Desination for DLLs
    # RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    RUNTIME DESTINATION bin

)