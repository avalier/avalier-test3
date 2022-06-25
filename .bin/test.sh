#!/bin/bash
set -o errexit	# Stop script on first error (non-zero returncode)
set -o pipefail	# Stop script on first error in a piped command (default only checks last pipe-command)
#set -o verbose	# Verbose debugprinting of executing scripts
#set -o xtrace	# Show commands being executed through debugprint during execution

CoverageThreshold=75

# Change directory to src folder based on location relative to the currently executing script #
ScriptLocation="$(realpath "${BASH_SOURCE[0]}")"
ScriptDirectory="$(dirname "${ScriptLocation}")"
cd $ScriptDirectory && cd ..
RootDirectory=$(pwd)
cd src

# Run unit tests and code coverage (and fail if code coverage threshold is not met) #
dotnet test Avalier.Test3.sln \
    /p:CollectCoverage=true \
    /p:CoverletOutputFormat=\"opencover,cobertura\" \
    /p:CoverletOutput=$RootDirectory/.out/ \
    /p:Threshold=$CoverageThreshold \
    /p:UseSourceLink=true
