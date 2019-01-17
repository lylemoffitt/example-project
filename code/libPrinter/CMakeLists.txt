cmake_minimum_required(VERSION 3.5)

# The name for this module of the project
set(MODULE_NAME Printer)
project(lib${MODULE_NAME}
    VERSION 1.0.0 
    LANGUAGES CXX
)

# Put together list of all source files
file(GLOB src_files
    ${PROJECT_SOURCE_DIR}/src/*.cpp
    ${PROJECT_SOURCE_DIR}/src/**/*.cpp
    # ${PROJECT_SOURCE_DIR}/src/*.h
    # ${PROJECT_SOURCE_DIR}/src/**/*.h
    # ${PROJECT_SOURCE_DIR}/include/*.h
    # ${PROJECT_SOURCE_DIR}/include/**/*.h
)

# Create library target
add_library(${MODULE_NAME} SHARED ${src_files})

# Set target include directories
target_include_directories(${MODULE_NAME}

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
target_compile_options(${MODULE_NAME} 
    PRIVATE 
        -Werror
)

# Set compiler features required by this target
target_compile_features(${MODULE_NAME}

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

# Add target to the list of exports for the module
install(TARGETS ${MODULE_NAME}
    
    # Export target identifier
    EXPORT ${PROJECT_NAME}_EXPORT

    # Install Destination for libraries (*.so)
    LIBRARY DESTINATION lib

    # Install Destination for archives (*.a)
    ARCHIVE DESTINATION lib

    # Install Desination for DLLs
    # RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

)

# Install the exported target
#   - Creates libPrinterTargets.cmake
install(EXPORT ${PROJECT_NAME}_EXPORT # Export ID as defined above
    
    # Name of cmake import script
    FILE ${MODULE_NAME}Config.cmake
    
    # Namespace to create target under
    NAMESPACE 
        Printer::

    # Directory to place the install script in
    DESTINATION 
        # ${CMAKE_INSTALL_LIBDIR}/cmake/lib${PROJECT_NAME}
        # share/${PROJECT_NAME}/cmake
        cmake
)

# Add directory to list of exports for the module
install(DIRECTORY include/

    # Install folders to system include directory
    DESTINATION include
)


# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# # just go into 'cmake'.
# install(EXPORT ${PROJECT_NAME}Config 
    # DESTINATION share/${PROJECT_NAME}/cmake)

# This makes the project importable from the build directory
export(TARGETS ${PROJECT_NAME}_EXPORT
    FILE ${MODULE_NAME}Config.cmake)



    # get_cmake_property(_variableNames VARIABLES)
    # list (SORT _variableNames)
    # foreach (_variableName ${_variableNames})
    #     message(STATUS "${_variableName}=${${_variableName}}")
    # endforeach()
    