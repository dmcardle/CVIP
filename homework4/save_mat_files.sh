#!/bin/bash

if [ -z "$1" ]
then
    echo "Error! Please specify name of this result set."
else
    echo
    echo "==== Creating directory \"evaluation/$1\""
    mkdir "evaluation/$1"

    echo
    echo "==== Writing .mat files to \"evaluation/$1\""
    cp -v genfeatures.mat svm_test_wspace.mat svm_train_wspace.mat "evaluation/$1"

    echo
    echo "==== Don't forget to save 1) the figure and 2) the contents of the output"
    echo
fi
