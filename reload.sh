#!/bin/bash

LAST_WD=$(pwd)

cd ./.kitchen/*/*/
vagrant halt
vagrant up --provision
cd $LAST_WD
