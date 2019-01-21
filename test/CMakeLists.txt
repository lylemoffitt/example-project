cmake_minimum_required(VERSION 3.5)

project(Test
    VERSION 1.0.0 
    LANGUAGES CXX
)

set (CMAKE_CXX_STANDARD 14)

message("CMAKE_MODULE_PATH          : " ${CMAKE_MODULE_PATH})
message("CMAKE_PREFIX_PATH          : " ${CMAKE_PREFIX_PATH})
message("CMAKE_INSTALL_PREFIX       : " ${CMAKE_INSTALL_PREFIX})
message("CMAKE_SOURCE_DIR           : " ${CMAKE_SOURCE_DIR})
message("CMAKE_CURRENT_SOURCE_DIR   : " ${CMAKE_CURRENT_SOURCE_DIR})
message("PROJECT_BINARY_DIR         : " ${PROJECT_BINARY_DIR})
message("PROJECT_SOURCE_DIR         : " ${PROJECT_SOURCE_DIR})


# Put together list of all source file
file(GLOB src_files
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/**/*.cpp
)

# Create executable target
add_executable(${PROJECT_NAME} ${src_files})

# Set target include directories
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
    PRIVATE 
        -Werror
)

# Set compiler features required by this target
# https://cmake.org/cmake/help/v3.1/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html
target_compile_features(${PROJECT_NAME} 
    PRIVATE 
        # cxx_std_11
)

enable_testing()
include_directories(${GTEST_INCLUDE_DIRS})


# Package must be found before it can be linked
#   - Execute FindGTest.cmake
find_package(GTest QUIET)

if( NOT GTest_FOUND)
    # add_subdirectory(../submodules/googletest)
    add_subdirectory(deps/gtest)

endif()



# Execute FindPrinter.cmake to get Printer::Printer
find_package(Printer QUIET COMPONENTS Printer)

# Directly build the subdirectory if it hasn't been found
if(NOT Printer_FOUND)
    message(STATUS 
        "libPrinter NOT FOUND: reverting to add_subdirectory")
    add_subdirectory(deps/libPrinter) 
endif()

# Set target links
target_link_libraries(${PROJECT_NAME} 
    
    # Targets links to expose to callers
    PUBLIC
        # Target with interface exposed in header
    
    # Targets to link against privately
    PRIVATE
        # Name of the printer library
        Printer::Printer
        # Printer # Not generic
        gtest_main
)



    # get_cmake_property(_variableNames VARIABLES)
    # list (SORT _variableNames)
    # foreach (_variableName ${_variableNames})
    #     message(STATUS "${_variableName}=${${_variableName}}")
    # endforeach()
    