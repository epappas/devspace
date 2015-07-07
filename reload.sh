#!/bin/bash

LAST_WD=$(pwd)

cd ./.kitchen/*/*/
vagrant halt
vagrant up
cd $LAST_WD
