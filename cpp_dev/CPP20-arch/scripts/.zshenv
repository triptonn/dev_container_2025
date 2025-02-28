#!/usr/bin/bash

# ster - Copyright [2025] <Nicolas Selig>
# executes a binary with arguments in bash
#
# Usage: ster -b <binary> -p <port_number>
#
#       -h | --help     Print help.
#
#       -b | --binary   Basename of the executable. 
#       -p | --port     Port the executable uses to communicate.
#

local ster_info="ster - Copyright [2025] <Nicolas Selig>\n
executes a binary with arguments in bash\n\n
Usage: ster -b <binary> -p <port_number>\n\n
    -h | --help     Print help.\n\n
    -b | --binary   Basename of the executable.\n
    -p | --port     Port the executable uses to communicate.\n\n"

ster() {
    local help_flag=false
    local port=""
    local binary=""
    while [[ "$1" == -* ]]; do
        case $1 in
            -b | --binary ) binary=$2; shift 2 ;;
            -p | --port ) port=$2; shift 2 ;;

            -h | --help) help_flag=true; echo "$ster_info"; break ;;
        esac
    done
    if [[ $help_flag == true ]]; then
        true
    elif [[ "$binary" == "" ]]; then
        echo "Error: Binary needs to be specified."
    elif [[ "$port" != "" ]]; then
        ./binaries/"${binary}" "${port}"
    else
        "./binaries/${binary}"
    fi
}

# ster end
#########################################################################

#########################################################################
# groo - Copyright [2025] <Nicolas Selig>
# TODO: Enter description and help
#
#

local groo_info="groo - Copyright [2025] <Nicolas Selig>\n
Compiles C++ file into binary using GCC.\n\n
Usage: groo <filename>\n\n
    -h | --help     Print help.\n\n"

function groo() {
    if [[ "$1" == "-h" ]]; then
        echo groo_info
        true
    else
        filename=$1
        base_name="${filename%.*}"
        if [[ ! -d ./binaries ]]; then
            echo "Creating directory ./binaries"
            mkdir "./binaries/"
        fi
        [[ -f "./binaries/${base_name}" ]] && rm "./binaries/${base_name}"
        gcc -g -lstdc++ -std=c++20 -pedantic "${base_name}.cpp" -o "./binaries/${base_name}" -time
    fi
}

# groo end
#########################################################################

#########################################################################
# clroo - Copyright [2025] <Nicolas Selig>
# TODO: Enter description and help
# 
#
local clroo_info="clroo - Copyright [2025] <Nicolas Selig>\n
Compiles C++ file into binary using clang.\n\n
Usage: clroo <filename>\n\n
    -h | --help     Print help.\n\n"

function clroo() {
    if [[ "$1" == "-h" ]]; then
        echo clroo_info
        true
    else
        local filename=$1
        local base_name="${filename%.*}"
        if [[ ! -d ./binaries ]]; then
            echo "Creating directory ./binaries"
            mkdir "./binaries/"
        fi
        [[ -f "./binaries/${base_name}" ]] && rm "./binaries/${base_name}"
        clang++ -g -lstdc++ -std=c++20 -pedantic "${base_name}.cpp" -o "./binaries/${base_name}" -time
    fi
}

# clroo end
#########################################################################
