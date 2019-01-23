cmake_minimum_required(VERSION 3.5)

set(NAMESPACE Printer)

# The name for this module of the project
set(TARGET Printer)
project(lib${TARGET}
    VERSION 1.0.0 
    LANGUAGES CXX
)

# Include guard prevents double definition of target
if(TARGET ${TARGET})
    return()
endif()

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
#   - Boolean will be passed literally as 'ON' or 'OFF'
set(opt_${TARGET}_with_newline
    ON # Defualt value
    CACHE BOOL
    "Append newline to every call to printer."
)

# Put together list of all source files
file(GLOB src_files
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/**/*.cpp
)


# Create library target
#   - Define the target name and it's build sources
#   - Include sources will be auto-generated with gcc -MMD
add_library(${TARGET} SHARED ${src_files})
#   - Alias the target under the module namespace
add_library(${NAMESPACE}::${TARGET} ALIAS ${TARGET})

# Set target include directories
target_include_directories(${TARGET}

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
)

# Set compiler options for this target
target_compile_options(${TARGET} 
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
target_compile_features(${TARGET}

    # Compiler featues we require of upstream consumers
    PUBLIC
        # cxx_std_11  # req. cmake v3.8
    
    # Internally we require some compiler features
    PRIVATE
        cxx_auto_type
        cxx_variadic_templates
)

# Set compiler properties for this target
#   - Explicitly set compiler version and other properties
# https://cmake.org/cmake/help/v3.4/manual/cmake-properties.7.html#target-properties
set_target_properties(${TARGET} 
    PROPERTIES
        CXX_STANDARD 11
        CXX_STANDARD_REQUIRED YES
        CXX_EXTENSIONS NO
)

# Define veriable for the target compilation
target_compile_definitions(${TARGET}
    PUBLIC
        # Compile library such that it (optionally) 
        # appends an endline
        #   - Convert option from {ON,OFF} to {1,0}
        APPEND_ENDLINE=$<BOOL:${opt_${TARGET}_with_newline}>
) 

# Add target to the list of exports for the module
install(TARGETS ${TARGET}
    
    # Export target identifier
    EXPORT ${TARGET}Config

    # Install Destination for libraries (*.so)
    LIBRARY DESTINATION lib

    # Install Destination for archives (*.a)
    ARCHIVE DESTINATION lib

    # Install Desination for DLLs
    # RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    RUNTIME DESTINATION bin

    # Install Destination for headers
    INCLUDES DESTINATION include

)

# Install the exported target
#   - Creates PrinterConfig.cmake
#   - Target will be picked up if CMAKE_MODULE_PATH contains CMAKE_INSTALL_PATH
install(EXPORT ${TARGET}Config # Export ID as defined above
    
    # Name of cmake import script
    # FILE ${MODULE_NAME}Config.cmake
    
    # Namespace to create target under
    NAMESPACE 
        ${NAMESPACE}::

    # Directory to place the install script in
    DESTINATION 
        # ${CMAKE_INSTALL_LIBDIR}/cmake/lib${PROJECT_NAME}
        # share/${TARGET}/cmake
        cmake
)

# Add directory to list of exports for the module
install(DIRECTORY include/

    # Install folders to system include directory
    DESTINATION 
        # include/${TARGET}
        include
)


# This makes the project importable from the build directory
export(TARGETS ${TARGET}
    FILE ${TARGET}Config.cmake
)

# Import some extra tools to help with writing a version file
include(CMakePackageConfigHelpers)

# Write a version compatability file to assist in package selection
write_basic_package_version_file(
    # Name of the version file
    ${TARGET}ConfigVersion.cmake

    # Version to write to the file
    VERSION ${PROJECT_VERSION}

    # Specify how much requested version can differ from provided
    #   - Requires the major version code matches
    COMPATIBILITY SameMajorVersion
)

# Print out all the variables, can also be done with 'cmake -LA'

    # get_cmake_property(_variableNames VARIABLES)
    # list (SORT _variableNames)
    # foreach (_variableName ${_variableNames})
    #     message(STATUS "${_variableName}=${${_variableName}}")
    # endforeach()
    