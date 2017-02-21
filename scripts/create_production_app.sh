#!/bin/bash
# This script is a preprocessor to build the production (final) Docker setup from the initial template.

set -e
# The path to this script file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# This is the namespace for our docker labels.
LABEL_DOMAIN=eu.simphony-project

. $DIR/functions.sh

display_help() {
  echo "Usage: $0 path/to/build.conf"
  echo
  echo "Creates a production directory containing the appropriate docker context"
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
extract_key "$config_file" "app_dir"
if [ -z "$RESULT" ]; then
    echo "Need app_dir in config file"
    display_help
    exit 1
fi
app_dir=$operating_dir/${RESULT%/}

extract_key "$config_file" "base_tag"
if [ -z "$RESULT" ]; then
    echo "Need base_tag in config file"
    display_help
    exit 1
fi
base_tag=`basename $RESULT`

# production directory
extract_key "$config_file" "production_dir"
if [ -z "$RESULT" ]; then
    echo "Need production_dir in config file"
    display_help
    exit 1
fi
production_dir=$operating_dir/${RESULT%/}
image_name=`basename $app_dir`

echo "Removing "$production_dir/$image_name
rm -rf $production_dir/$image_name

echo "Creating "$production_dir/$image_name
mkdir -p $production_dir/$image_name

echo "Copying files from " $app_dir " to " $production_dir/$image_name
rsync -a --exclude='*~' $app_dir/* $production_dir/$image_name/

# Create the final Dockerfile from the "template" one

# Replace the tag in the docker file FROM entry
# Get it out of the way so if it fails we are guaranteed not to use a broken dockerfile.
mv $production_dir/$image_name/Dockerfile $production_dir/$image_name/Dockerfile.template 
sed 's/^FROM \([^:]*\)/FROM \1:'$base_tag'/g' $production_dir/$image_name/Dockerfile.template > $production_dir/$image_name/Dockerfile.build
rm $production_dir/$image_name/Dockerfile.template 

# if there's an icon, base encode it and use it.
if [ -e $production_dir/$image_name/icon_128.png ]; then
    b64encode $production_dir/$image_name/icon_128.png
    echo "LABEL ${LABEL_DOMAIN}.docker.icon_128=\"${RESULT}\"" >>$production_dir/$image_name/Dockerfile.build
fi

# Set the final dockerfile from the one just built
mv $production_dir/$image_name/Dockerfile.build $production_dir/$image_name/Dockerfile

echo "***********************************************************************"
echo "Now all the files for Docker build are in $production_dir/$image_name"
echo "***********************************************************************"
