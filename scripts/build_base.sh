#!/bin/bash
# This scripts rebuilds the whole set of containers. Be careful because it invalidates previous
# containers already stored in the docker server.

# The path to this script file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/functions.sh

display_help() {
  echo "Usage: $0 config_file"
  echo
  echo "Builds all the containers from the production directory specified in the configuration file."
}

if [ -z "$1" ]; then
    echo "Need path to the config file"
    echo 
    display_help
    exit 1
fi

config_file=$1
operating_dir=`dirname $config_file`/

# production directory
extract_key "$config_file" "production_dir"
if [ -z "$RESULT" ]; then
    echo "Need production_dir in config file"
    display_help
    exit 1
fi
production_dir=$operating_dir/${RESULT%/}

# The directory that contains all base images
extract_key "$config_file" "image_prefix"
if [ -z "$RESULT" ]; then
    echo "Need image_prefix in config file"
    display_help
    exit 1
fi
image_prefix=${RESULT}

# The directory that contains all base images
extract_key "$config_file" "tag"
if [ -z "$RESULT" ]; then
    echo "Need tag in config file"
    display_help
    exit 1
fi
tag=${RESULT}

# Construct docker context for production
for entry in `ls -d $production_dir/*/`; do
    # One sub-directory for each image
    image_name=`basename $entry`
    echo "Building "$entry 

    docker build --no-cache --rm -f $entry/Dockerfile -t $image_prefix/$image_name:$tag .

    if test $? -ne 0; then
        echo "Error occurred while building $entry. Exiting"
        exit
    fi
done
