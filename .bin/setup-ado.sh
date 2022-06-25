#!/bin/bash

DEVOPS_NAME=avalier
PROJECT=$1

if [ -z $PROJECT ]
then
    echo "Usage: $0 <<Project>>"
    exit 0
fi

# Change directory to src folder based on location relative to the currently executing script #
ScriptLocation="$(realpath "${BASH_SOURCE[0]}")"
ScriptDirectory="$(dirname "${ScriptLocation}")"
cd $ScriptDirectory && cd ..

./.bin/setup-ado-repository.sh $PROJECT
./.bin/setup-ado-pipeline.sh $PROJECT

