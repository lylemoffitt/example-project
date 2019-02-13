
include(GetGitRevisionDescription)


function(git_commit_hash _out_var_)
    get_git_head_revision(refspec hash)
    if(NOT hash)
        set(${_var} "HEAD-HASH-NOTFOUND" PARENT_SCOPE)
        return()
    endif()
    execute_process(
        COMMAND git rev-parse ${hash}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE stdout
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(${_out_var_} "${stdout}" PARENT_SCOPE)
endfunction(git_commit_hash)


function(git_describe _out_var_)
    get_git_head_revision(refspec hash)
    if(NOT hash)
        set(${_var} "HEAD-HASH-NOTFOUND" PARENT_SCOPE)
        return()
    endif()
    execute_process(
        COMMAND git describe ${hash}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE stdout
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(${_out_var_} "${stdout}" PARENT_SCOPE)
endfunction(git_describe)


function(git_remote_url _out_var_)
    execute_process(
        COMMAND git remote
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_REMOTE
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
        COMMAND git remote get-url ${GIT_REMOTE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE stdout
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(${_out_var_} "${stdout}" PARENT_SCOPE)
endfunction(git_remote_url)


function(git_current_branch _out_var_)
    get_git_head_revision(refspec hash)
    if(NOT hash)
        set(${_var} "HEAD-HASH-NOTFOUND" PARENT_SCOPE)
        return()
    endif()
    execute_process(
        COMMAND git rev-parse --abbrev-ref ${hash}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        OUTPUT_VARIABLE stdout
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(${_out_var_} "${stdout}" PARENT_SCOPE)
endfunction(git_current_branch)


function(git_local_changes _out_var_)
    get_git_head_revision(refspec hash)
    if(NOT hash)
        set(${_var} "HEAD-HASH-NOTFOUND" PARENT_SCOPE)
        return()
    endif()
    execute_process(
        COMMAND git diff --quiet ${hash}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE res
    )
    set(${_out_var_} ${res} PARENT_SCOPE)
endfunction(git_local_changes)