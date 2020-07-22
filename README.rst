Docker specification for SimPhoNy Remote App project
====================================================

Scripts for composing Dockerfiles that support remote access using Simphony-remote web
application.  Built docker images are hosted on DockerHub under the Simphony Organisation.

This repository obsoletes ``simphony-remote-docker``. Provides scripts to be used on the
repositories containing the base images (```simphony-remote-docker-base``) and application
images (e.g. ``simphony-remote-docker-jupyter-notebook``)


Overall concept and layout
--------------------------

We build images by combining three parts:

1. A base docker file (a plain ubuntu with some personalized additions)
2. Boilerplate that just sets up the basics of the infrastructure (e.g. vnc)
3. For application images, the specifics for our application

The composition is done by copying and deploying the first two together in a base image + wrapper
and then use docker building facilities to generate the image. Note that Dockerfile
files are properly generated and merged together.

Automation of these points is provided in the ``scripts`` directory.
These scripts are driven by a configuration file ``build.conf``. Details of its usage are
provided `here <docs/build_conf_format.rst>`_.

Quick Setup docker image
------------------------

This example will show how to build a Simphony-Remote application running a simple Mayavi 3D visualisation on an Ubuntu
base image. It will require access to both ``simphony-remote-docker-base`` and ``simphony-remote-docker-mayavi`` repositories,
as well as a working version of Docker.

If you have not already cloned these repositories, please do so via the links below:

https://github.com/simphony/simphony-remote-docker-base
https://github.com/simphony/simphony-remote-docker-mayavi

    .. note::
       This guide assumes you have a working installation of Docker. If you haven't already obtained
       one alongside Simphony-Remote, please do so via `the Docker website <https://docs.docker.com/engine/installation/linux/ubuntulinux/>`_.

#. A docker image for a demo application using Mayavi can be created by using the generic scripts in
   the ``scripts`` directory::

     cd simphony-remote-docker-scripts/scripts

#. First, create a base image (an image with the Ubuntu OS and supporting vnc/web libraries)::

     bash create_production_base.sh <path-to>/simphony-remote-docker-base/build.conf
     bash build_base.sh <path-to>/simphony-remote-docker-base/build.conf

#. Next, create an image with the demo Mayavi application (this is built on top of the base image)::

     bash create_production_app.sh <path-to>/simphony-remote-docker-mayavi/build.conf
     bash build_app.sh <path-to>/simphony-remote-docker-mayavi/build.conf

   An image called ``mayavi-app`` should now be visible in your local docker repo by running::

    docker images

Other topics
------------
- `Base OS images <docs/base_images.rst>`_
- `Making application images <docs/make_own_app.rst>`_
- `Develop and deploy the images <docs/develop_and_deploy.rst>`_
- `Debugging tips <docs/debugging.rst>`_

