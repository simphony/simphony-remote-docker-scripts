#!/bin/bash
# This scripts builds the application. Be careful because it invalidates previous
# containers already stored in the docker server.
# It is designed to be a convenience wrapper to pass the right arguments to docker build, 
# extracting them from the config file. It must be possible to perform the build anyway 
# just with plain docker build, only that the parameters must be specified manually. 

# The path to this script file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/functions.sh

display_help() {
  echo "Usage: $0 config_file"
  echo
  echo "Builds the application from the production directory specified in the configuration file."
}

if [ -z "$1" ]; then
    echo "Need path to the config file"
    echo 
    display_help
    exit 1
fi

config_file=$1
operating_dir=`dirname $config_file`/

extract_key "$config_file" "production_dir"
if [ -z "$RESULT" ]; then
    echo "Need production_dir in config file"
    display_help
    exit 1
fi
production_dir=$operating_dir/${RESULT%/}

# The directory that contains all base images
extract_key "$config_file" "app_dir"
if [ -z "$RESULT" ]; then
    echo "Need app_dir in config file"
    display_help
    exit 1
fi
app_dir=$operating_dir/${RESULT%/}
image_name=`basename $app_dir`

# The directory that contains all base images
extract_key "$config_file" "tag"
if [ -z "$RESULT" ]; then
    echo "Need tag in config file"
    display_help
    exit 1
fi
tag=${RESULT}

# The directory that contains all base images
extract_key "$config_file" "image_prefix"
if [ -z "$RESULT" ]; then
    echo "Need image_prefix in config file"
    display_help
    exit 1
fi
image_prefix=${RESULT}

echo "Building "$image_name

pushd $production_dir/$image_name

docker build --no-cache --rm -f Dockerfile -t $image_prefix/$image_name:$tag .

if test $? -ne 0; then
    echo "Error occurred while building $image_name. Exiting"
    exit
fi
