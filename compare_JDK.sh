#!/bin/bash

# Common Functions
helps()
{
   echo '####################################################'
   echo 'Download artifact/asset from given Temurin release.'
   echo
   echo "Syntax: $0"
   echo "Usage: $0 <jdk_version> <release_name> [local_folder]"
   echo "arguments:"
   echo "jdk_version     8,11,17,19,..."
   echo "release_name    tag name or release name, e.g jdk-17.0.5+8"
   echo "local_folder	 relative path of original local files are stored, if skip use current path"
}


downloadJDK()
{
	curl -s  "${github_api}" | grep browser_download_url | awk '{ print  $2 }' | xargs wget -q
	asset_count=$(curl -s "${github_api}" | jq '.assets |length')
	local_count=$(ls OpenJDK"${jdkversion}" | wc -l)
	echo "GH release ${tag_name} has ${asset_count} assets, downloaded to ${local_count} to local folder ${tag_name}"
}


comparision()
{
	diff "${local_folder}" "${tag_name}"
}



# Pre-Check
if [ "$#" -lt 2 ]; then
    echo "Error: Require both jdk version and tag name, abort job"
    helps
    exit 1
fi
local_folder=$PWD
if [ "$#" -eq 3 ]; then
	if [ ! -d "$3" ]; then
    		echo "Error: local_folder $3 does not exist, abort job"		
    		helps
    		exit 1
	else
    		local_folder="$3"
	fi
fi
jdkversion=$1 	# "17"
tag_name=$2 	# "jdk-17.0.5+8"
github_api="https://api.github.com/repos/adoptium/temurin${jdkversion}-binaries/releases/tags/${tag_name}"
echo "Happy Downloading ${tag_name}......"

# Main logic
mkdir "${tag_name}" && cd "${tag_name}"
downloadJDK
comparision 

