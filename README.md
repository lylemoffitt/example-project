# example-project
A project that exemplifies many things

References:
- [1](https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/)
- [2](https://rix0r.nl/blog/2015/08/13/cmake-guide/)
- [3](https://gitlab.kitware.com/cmake/community/wikis/doc/tutorials/How-to-create-a-ProjectConfig.cmake-file)


## CMake Project Goals

Things this project can do:

- Build C++ sources
- Install headers
- Install dynamic libraries
- Install executables
- Support Debug/Release builds
- Support inclusion via `add_subdirectory`
- Support inclusion via `find_package`
- Build tests
- Run tests
- Configure projects with version info
- Store semver code in binary
- Store git hash in binary
- Accommodate 3rd party builds/projects/package structures (via symlinker)


Things this project should do:

- Build documentation
- Install documentation
- Auto-convert `gtest`/`catch` unit tests to `ctest`
- Auto-run tests 
- force rebuild on git hash change
- Build target introspection (more verbose/granular build targets)


Things this project _could_ do:

- Support external configuration via JSON object
- Auto init submodules
- Download 3rd party libraries via source URL
- Run linters as prebuild step
- Support pre-compiled header
- Package tarballs
- 


## Mirroring heterogeneous projects

1) Proxy project via extension via a cmake lists into the normal project
    - the eproject is linked as a submodule and linked via deps

2) Top level cmake just points straight into submodules and includes it directly

3) Symlink from code/Project directly to submoudle/Project


## Catkin Project structure

Src folder structure is inforced
