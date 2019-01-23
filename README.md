# example-project
A project that exemplifies many things

References:
    - [1](https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/)
    - [2](https://rix0r.nl/blog/2015/08/13/cmake-guide/)
    - [3](https://gitlab.kitware.com/cmake/community/wikis/doc/tutorials/How-to-create-a-ProjectConfig.cmake-file)


## CMake Project Goals

Things this project can do

    - Build C++ sources
    - Install headers
    - Install dynamic libraries
    - Install executables
    - Support Debug/Release builds
    - Support inclusion via `add_subdirectory`
    - Support inclusion via `find_package`
    - Build tests
    - Run tests


Things this project should do

    - Configure projects with version info
    - Store semver code in binary
    - Store git hash in binary
    - Build documentation
    - Install documentation
    - Auto-convert gtest/catch unit tests to ctest