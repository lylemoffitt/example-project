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
message("CMAKE_CURRENT_SOURCE_DIR   : " ${CMAKE_CURRENT_SOURCE_DIR})
message("PROJECT_BINARY_DIR         : " ${PROJECT_BINARY_DIR})
message("PROJECT_SOURCE_DIR         : " ${PROJECT_SOURCE_DIR})

# Put together list of all source files
file(GLOB src_files
    ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/**/*.cpp
    # ${PROJECT_SOURCE_DIR}/src/*.h
    # ${PROJECT_SOURCE_DIR}/src/**/*.h
    # ${PROJECT_SOURCE_DIR}/include/*.h
    # ${PROJECT_SOURCE_DIR}/include/**/*.h
)

file(GLOB_RECURSE header_files 
    ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h*
    ${CMAKE_CURRENT_SOURCE_DIR}/include/**/*.h*
)


# Set directories to include for this project
#   - Needed for any project which usesthis one via add_subdirectory
# include_directories(
#     # include
#     # ${PROJECT_SOURCE_DIR}/include
#     ${CMAKE_CURRENT_SOURCE_DIR}/include
# )

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
        # $<INSTALL_INTERFACE:include/${TARGET}>
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
target_compile_options(${TARGET} 
    PRIVATE 
        -Werror
)

# Set compiler features required by this target
# https://cmake.org/cmake/help/v3.1/prop_gbl/CMAKE_CXX_KNOWN_FEATURES.html
target_compile_features(${TARGET}

    # We require C++11 support and them same applies to consumers since
    #   STL is in our API
    PUBLIC
        # cxx_std_11
    
    # Internally we require some compiler features, but we won't require 
    #   upstream consumers to also support them
    PRIVATE
        cxx_auto_type
        cxx_variadic_templates
)

# Define veriable for the target compilation
target_compile_definitions(${TARGET}
    PRIVATE
        APPEND_ENDLINE=1
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
#   - Creates libPrinterTargets.cmake
install(EXPORT ${TARGET}Config # Export ID as defined above
    
    # Name of cmake import script
    # FILE ${MODULE_NAME}Config.cmake
    
    # Namespace to create target under
    NAMESPACE 
        ${NAMESPACE}::

    # Directory to place the install script in
    DESTINATION 
        # ${CMAKE_INSTALL_LIBDIR}/cmake/lib${PROJECT_NAME}
        # share/${PROJECT_NAME}/cmake
        cmake
)

# Install the header files. 
# The DESTINATION should match with the INSTALL_INTERFACE above.
install(FILES ${header_files}
     DESTINATION include/${TARGET}
)

# Add directory to list of exports for the module
install(DIRECTORY include/

    # Install folders to system include directory
    DESTINATION include/${TARGET}
)


# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# # just go into 'cmake'.
# install(EXPORT ${TARGET}Config 
#     DESTINATION share/${TARGET}/cmake
# )

# This makes the project importable from the build directory
export(TARGETS ${TARGET}
    FILE ${TARGET}Config.cmake
)



    # get_cmake_property(_variableNames VARIABLES)
    # list (SORT _variableNames)
    # foreach (_variableName ${_variableNames})
    #     message(STATUS "${_variableName}=${${_variableName}}")
    # endforeach()
    