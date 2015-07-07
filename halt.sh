#!/bin/bash

LAST_WD=$(pwd)

cd ./.kitchen/*/*/
vagrant halt
cd $LAST_WD
