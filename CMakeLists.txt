# Top Leve CMakeLists
#   - Optional single entry point convience
#   - Bring all sub projects into scope
#   - Build them together
#   - Define where to install them


# Load the GNUInstallDirs cmake module
#   - Sets CMAKE_INSTALL_LIBDIR to cononical install location for platform
include(GNUInstallDirs)

cmake_minimum_required(VERSION 3.5)


add_subdirectory(code/hello)
add_subdirectory(code/libPrinter)
add_subdirectory(test)