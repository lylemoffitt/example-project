cmake_minimum_required(VERSION 3.5)

project(Hello
    VERSION 1.0.0 
    LANGUAGES CXX
)

# Put together list of all source file
file(GLOB src_files
    ${PROJECT_SOURCE_DIR}/src/*.cpp
    ${PROJECT_SOURCE_DIR}/src/**/*.cpp
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
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Set compiler options for this target
target_compile_options(${PROJECT_NAME} 
    PRIVATE 
        -Werror
)

# Set compiler features required by this target
target_compile_features(${PROJECT_NAME} 
    PRIVATE 
        # cxx_std_11
)

# Package must be found before it can be linked
#   - Execute FindBoost.cmake to get Boost::program_options
find_package(Boost 1.55 REQUIRED COMPONENTS program_options)

#   - Execute FindPrinter.cmake to get Printer::libPrinter
# find_package(Printer REQUIRED COMPONENTS libPrinter)

# Directly build the subdirectory if ithasn't been found
# if(NOT Printer_FOUND)
   add_subdirectory(../libPrinter) 
# endif()


# Set target links
target_link_libraries(${PROJECT_NAME} 
    
    # Targets links to expose to callers
    PUBLIC
        # Target with interface exposed in header
    
    # Targets to link against privately
    PRIVATE
        Boost::program_options
        Printer::libPrinter
)