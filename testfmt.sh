#!/bin/bash

# Note the set -ev at the top. 
# The -e flag causes the script to exit as soon as one command returns a non-zero exit code. 
# This can be handy if you want whatever script you have to exit early. 
# It also helps in complex installation scripts where one failed command wouldn’t otherwise cause the installation to fail.
# The -v flag makes the shell print all lines in the script before executing them, 
# which helps identify which steps failed.
set -ev

if [[ -n $(gofmt -d .) ]]; then 
	gofmt -d .
 	exit 1
fi

if [[ -n $(gofmt -d ./na64) ]]; then 
	gofmt -d ./na64
 	exit 1
fi

if [[ -n $(gofmt -d ./na32) ]]; then 
	gofmt -d ./na32
 	exit 1
fi
