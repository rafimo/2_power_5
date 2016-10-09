#!/bin/bash -a
# cerner_2^5_2016

# More alphabet printing!
# Help: ./A.sh a

trap 'missing $BASH_COMMAND' ERR

function missing() {
    echo -ne `basename $1`
    increment $1
}

function increment() {
    b=`basename $1 | tr "0-9a-z" "1-9a-z_"`
    if [ $b != "_" ]; then
        eval $0 $b
        exit
    fi
    echo && exit
}

eval /tmp/$1 2> /dev/null