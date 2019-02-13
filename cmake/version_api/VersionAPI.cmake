
# Prevent multiple includes per project
if(__VersionAPI_include_guard)
	return()
endif()
set(__VersionAPI_include_guard YES)


# Resolve this module file to its realpath
get_filename_component(__VersionAPI_PATH
    ${CMAKE_CURRENT_LIST_FILE}
    REALPATH
)

# Convert real module path to module directory
get_filename_component(__VersionAPI_DIR 
    ${__VersionAPI_PATH}
    DIRECTORY
)

list(APPEND CMAKE_MODULE_PATH "${__VersionAPI_DIR}/import")

# Get version module
include(GitVersionInfo)


#[=============================================================================[
    generate_version_block( <src_var> )
#]=============================================================================]
function(generate_version_block 
    _src_var_       # Store SRC path
)
    git_commit_hash(GIT_HASH)
    git_describe(GIT_DESC)
    git_remote_url(GIT_REMOTE_URL)
    git_current_branch(GIT_BRANCH)
    git_local_changes(GIT_DIRTY)

    configure_file( # Static binary version block
        ${__VersionAPI_DIR}/src/version_block.cpp.in
        ${CMAKE_CURRENT_BINARY_DIR}/version_api/src/version_block.cpp
    )

    set(${_include_var_} 
        ${CMAKE_CURRENT_BINARY_DIR}/version_api/src/
        PARENT_SCOPE
    )
endfunction()

#[=============================================================================[
    generate_version_block( <src_var> <include_var> )
#]=============================================================================]
function(generate_version_rt_api
    _src_var_       # Store SRC path
    _include_var_   # Store INCLUDE path
)
    git_commit_hash(GIT_HASH)
    git_describe(GIT_DESC)
    git_remote_url(GIT_REMOTE_URL)
    git_current_branch(GIT_BRANCH)
    git_local_changes(GIT_DIRTY)

    configure_file( # Run-time Version API
        ${__VersionAPI_DIR}/src/version_api.cpp.in
        ${CMAKE_CURRENT_BINARY_DIR}/version_api/src/version_api.cpp
    )
    
    set(${_src_var_} 
        ${CMAKE_CURRENT_BINARY_DIR}/version_api/src/
        PARENT_SCOPE
    )
    set(${_include_var_} 
        ${__VersionAPI_DIR}/include/
        PARENT_SCOPE
    )
endfunction()

#[=============================================================================[
    generate_version_block( <include_var> )
#]=============================================================================]
function(generate_version_ct_api
    _include_var_   # Store INCLUDE path
)
    git_commit_hash(GIT_HASH)
    git_describe(GIT_DESC)
    git_remote_url(GIT_REMOTE_URL)
    git_current_branch(GIT_BRANCH)
    git_local_changes(GIT_DIRTY)

    configure_file( # Compile-time Version API
        ${__VersionAPI_DIR}/include/version_ct_api.hpp.in
        ${CMAKE_CURRENT_BINARY_DIR}/version_api/include/version_ct_api.hpp
    )

    set(${_include_var_} 
        ${CMAKE_CURRENT_BINARY_DIR}/version_api/include/
        PARENT_SCOPE
    )
endfunction()