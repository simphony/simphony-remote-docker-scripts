#!/bin/bash
# This script is used for deploying the buildable docker files from the user-specified template.
set -e
# The path to this script file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/functions.sh

display_help() {
  echo "Usage: $0 path/to/build.conf"
  echo
  echo "Creates a production directory containing the appropriate docker context."
  echo
}

if [ -z "$1" ]; then
    echo "Need path to the config file"
    echo
    display_help
    exit 1
fi

config_file=$1
operating_dir=`dirname $config_file`/

# The directory that contains all base images
extract_key "$config_file" "base_images_dir"
if [ -z "$RESULT" ]; then
    echo "Need base_images_dir in config file"
    display_help
    exit 1
fi
base_images_dir=$operating_dir/${RESULT}

# production directory
extract_key "$config_file" "production_dir"
if [ -z "$RESULT" ]; then
    echo "Need production_dir in config file"
    display_help
    exit 1
fi
production_dir=$operating_dir/${RESULT}

# The directory that provides the front-end/back-end support for remote access
extract_key "$config_file" "wrappers_dir"
if [ -z "$RESULT" ]; then
    echo "Need wrappers_dir in config file"
    display_help
    exit 1
fi
wrappers_dir=$operating_dir/${RESULT%/}

extract_key "$config_file" "build_base"
if [ -z "$RESULT" ]; then
    echo "Need build_base in config file"
    display_help
    exit 1
fi
build_base=$RESULT

# Construct docker context for production
for entry in $build_base; do
    base_image_name=`echo $entry | cut -d':' -f1`
    wrapper_name=`echo $entry | cut -d':' -f2`
    final_image_name=${base_image_name}-${wrapper_name}

    # One sub-directory for each image
    echo "Removing "$production_dir/$final_image_name
    rm -rf $production_dir/$final_image_name
    echo "Creating "$production_dir/$final_image_name
    mkdir -p $production_dir/$final_image_name

    # Copy files from the image directory to the production sub-directory
    echo "Copying files from $base_images_dir/$base_image_name to $production_dir/$final_image_name/"
    rsync -a --exclude='*~' $base_images_dir/$base_image_name/* $production_dir/$final_image_name/

    echo "Copying files from $wrappers_dir/$wrapper_name to $production_dir/$final_image_name/"
    rsync -a --exclude='*~' $wrappers_dir/$wrapper_name/* $production_dir/$final_image_name/

    # Append wrapper's Dockerfile to the one for the image
    grep -ve '^FROM' $production_dir/$final_image_name/Dockerfile.template >> $production_dir/$final_image_name/Dockerfile
done

echo "***********************************************************************"
echo "Now all the files for Docker build are ready in $production_dir"
echo "***********************************************************************"
