Development/Deployment for DockerHub Repo
-----------------------------------------

Build images (for apps)
'''''''''''''''''''''''

It is assumed that you have the ``simphony-remote-docker/scripts`` in your path.
To generate the usable Docker layout, follow these steps:

1. go into and checkout the appropriate commit of the application you want to build, then modify the 
   ``build.conf`` to the appropriate values.
   Available base tags for the build can be found on ``simphonyproject/ubuntu-12.04-2-vncapp`` or 
   ``simphonyproject/ubuntu-14.04-2-vncapp/webapp`` on DockerHub. If you are doing development
   you should use ``latest``. If you are releasing a version, you should pick an appropriate
   one. This base tag will be added as the FROM dependency of your application build.

2. do::

     $ create_production_app.sh ./build.conf

   This generates the `production` directory containing the buildable Dockerfiles and 
   the associated files.

These two steps are enough to create the buildable Dockerfiles and the associated
files. Skip to `Development` section if that's all you need to perform development,
or continue to do a production release.

The procedure to rebuild the base images is similar, but a different script
``create_production_base.sh`` is used. This script is peculiar for the fact that
base images are built by combination of two parts. The script assembles the parts and
creates the required combinations.

Configure Docker Hub
''''''''''''''''''''

To do deployment and autobuild, first you have to have a github repo setup for your application.
You must commit the generated production directory too, as Docker Hub does not
allow anything more than running ``docker build`` on a Dockerfile.

Taking the ``simphony-remote-docker-filemanager`` repository as an example, the steps are:

1. Go to ``hub.docker.com`` and log in with your credentials to the ``simphonyproject``.
   You need to be authorized to do so.

2. Click `Create > Create automated build` in the topbar menu.

3. Click the giant ``create auto build Github`` button, 
   select ``simphony`` and ``simphony-remote-docker-filemanager``. This will create a new build
   bound to that github repository.

4. Specify the conventional name (same as the directory you got out of
   ``production``: ``filemanager``), title, and description. Click the customize button, and specify
   two entries in the resulting list:
   
   - Push type: Branch, Name: master, Dockerfile location: ``/production/filemanager``, Docker tag: latest.
   - Push type: tag, Name ``/^[0-9.]+$/``, Dockerfile location: ``/production/filemanager``, Docker tag: <leave empty>

Now DockerHub is ready to automatically build the filemanager image when you push appropriately.
It will also build with the appropriate tag when you push with --tags a new tag.

**IMPORTANT**: Docker hub has a limitation of two hours for the build, on a rather slow machine.
If your image takes too much time to build, you will have to build locally and then push the image.
Be aware that you might incur disk space issues in this case.


Development
-----------

The scripts directory contains building scripts to build the images in the
``production`` directory. Running the appropriate ``create_production`` scripts is therefore
needed before using these scripts. 

- ./scripts/build\_base.sh: Build base docker images from which other application docker images are built upon

- ./scripts/build\_app.sh: Build application docker images. This script is nothing more than a fancy way
  of invoking docker build, with the only difference that it extracts prefix, tag and Dockerfile location info from 
  the ``build.conf`` file.
 
IMPORTANT: if you deploy new images, do ensure that containers from the old images are deleted,
otherwise the user will continue to use the old container instead of creating a new one from
the new images.  To do so, check ``docker ps -a`` and then do ``docker rm`` of all the obsolete containers.

For example, to build a base image from the base docker and the wrapper script, do::
 
  $ ./scripts/build_base.sh ./build.conf
 
 To build an application image::
 
  $ ./scripts/build_app.sh ./build.conf

