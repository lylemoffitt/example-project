#!/usr/bin/env bash

usage()
{
cat <<HEREDOC

Usage: $(basename $0) [validate|generate|forall <command>] [--verbose] [--recurse] [<path>]

Verbs:
    validate    Checks that all symlinks are mirrored in a .symlink file
                and vise versa.

    generate    Generate symlinks from .symlink files.

    forall      Apply <command> in the directory of a .symlink file, for 
                every link in that file. Exposes the following variables:
                    - LINK_ROOT: Path the .symlink file is located in.
                    - LINK_NAME: Name of the link in the file.
                    - LINK_DEST: Where the .symlink should point.

Flags:
    --verbose   Print messages

    --recurse   Apply the verb in every directory where a .symlink file is
                found under the given <path>.
HEREDOC
}

# Program Config
LINK_FILE_NAME=".symlink"

# Set argument vars
OP_VALIDATE=0
OP_GENERATE=0
OP_VERBOSE=0
# OP_FINDALL=0
OP_FORALL=0

ARG_FORALL=""

ARG_PATH=""
WORK_DIR=""

# Check command line parameters.
if [ $# -eq 0 ]; then
    usage
    exit
fi
while [ $# -gt 0 ]; do
    case $1 in
        --validate)
            OP_VALIDATE=1
            OP_GENERATE=0
            ;;
        --generate)
            OP_GENERATE=1
            OP_VALIDATE=0
            ;;
        --verbose)
            OP_VERBOSE=1
            ;;
        --findall)
            OP_FINDALL=1
            ;;
        --forall)
            shift
            OP_FORALL=1
            ARG_FORALL="$1"
            ;;
        *)
            if [ -e "$1" ];then
                ARG_PATH="$1"
            else
                usage
            fi
            exit 1
            ;;
    esac
    shift
done

# Prep WORK_DIR variable
if [ -d "${ARG_PATH}" ];then
    WORK_DIR="${ARG_PATH}"
fi
if [ -f "${ARG_PATH}" ];then
    WORK_DIR="$(dirname "${ARG_PATH}")"
fi

err(){
    echo "$*" >&2
}

apply_shell_command(){
    LINK_ROOT="$1" \
    LINK_NAME="$2" \
    LINK_DEST="$3" \
    sh -c "cd $LINK_ROOT; $ARG_FORALL"
}


# Check that link in file is on disk
validate_link_exists(){
    LINK_ROOT="$1"
    LINK_NAME="$2"
    LINK_DEST="$3"

    if [ ! $OP_VALIDATE -gt 0 ]; then
        return 0
    fi

    if [ ! -L "${LINK_ROOT}/${LINK_NAME}" ];then
        err "symlink not found: ${LINK_ROOT}/${LINK_NAME}"
    fi
    if [ "$(readlink "${LINK_ROOT}/${LINK_NAME}")" != "${LINK_DEST}" ]; then
        err "symlink mismatch: ${LINK_ROOT}/${LINK_NAME} =!=> ${LINK_DEST}"
    fi
    if [ $OP_VERBOSE -gt 0 ]; then
        echo "symlink exists: ${LINK_ROOT}/${LINK_NAME}"
    fi
}

# Check that link on disk is in file
validate_link_registered(){
    LINK_ROOT="$1"
    LINK_NAME="$2"
    LINK_DEST="$3"

    if [ ! $OP_VALIDATE -gt 0 ]; then
        return 0
    fi
    MATCH_FOUND=0
    for link_item in $(find "$LINK_ROOT" -maxdepth 1 -type l); do
        if [ "$(basename "$link_item")" == "$LINK_NAME" ] ; then
            if [ "$(readlink "${LINK_ROOT}/${link_item}")" == "${LINK_DEST}" ]; then
                MATCH_FOUND=1
                return 0
            else
                err "symlink mismatch: ${LINK_ROOT}/${link_item} =!=> ${LINK_DEST}"
            fi
        fi
    done
    if [ $MATCH_FOUND -eq 0 ];then
        err "symlink unknown: ${LINK_ROOT}/${link_item}"
        return 1
    fi
}

# Create the link on disk
create_link(){
    LINK_ROOT="$1"
    LINK_NAME="$2"
    LINK_DEST="$3"
    LINK_SRC="${LINK_ROOT}/${LINK_DEST}"

    if [ ! $OP_GENERATE -gt 0 ]; then
        return 0
    fi

    if [ $OP_VERBOSE -gt 0 ]; then
        echo "creating link: $LINK_SRC --> $LINK_DEST"
    fi
    ln -s "$LINK_DEST" "$LINK_SRC"
}

strip(){
    sed -nE '
        # Strip comments at start of line
        s/#.*//
        
        # Strip comments at end of line
        s/([^#]+ )(#.*)/\1/

        # Strip ??
        # s/[ ^I]*$//

        # Strip empty lines
        /^\s*$/ d

        # Passtrough everything else
        p
    '
}

parse(){
    sed -nE '
        s;\s*([^\n"?:*<>|\/]+)\s+(/\.\.?\/[^\n"?:*<>|]+);\1 \2;
    '
}

map_link_file(){
    LINK_ROOT="$1"
    shift
    CMD_LIST="$*"
    while read LINK_NAME LINK_DEST extra ; do
        if [ -n "$extra" ]; then
            err "parse error: lines may only have two items; wtf is '$extra'"
            continue
        fi
        for cmd in $CMD_LIST ; do
            eval "$cmd" "${LINK_ROOT}" "${LINK_NAME}" "${LINK_DEST}"
        done
    done
}


find_link_files(){
    if [ $OP_FINDALL -gt 0 ]; then
        find "${WORK_DIR}" -name "${LINK_FILE_NAME}"
    elif [ -f "${WORK_DIR}/${LINK_FILE_NAME}" ];then
        echo "${WORK_DIR}/${LINK_FILE_NAME}"
    fi
}


for file in $(find_link_files); do
    if [ "$(basename "${file}" )" != "${LINK_FILE_NAME}" ]; then
        err "attemt to read invalid symlink file: $file"
        continue
    fi
    
    cat "${file}" \
        | strip \
        | map_link_file "${file}" \
            create_link \
            validate_link_exists \
            apply_shell_command \
            echo
done