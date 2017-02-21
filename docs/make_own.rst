Make your own Docker images
---------------------------

To build your own image, you need to create a base directory (which is normally a github repo).
Inside this directory, you need:
 - a ``build.conf`` file 
 - a directory named like the image (e.g. ``myprogram``).

Inside the ``myprogram`` directory, you must have:

- a Dockerfile
- optionally: a ``icon_128.png`` file containing the icon in 128x128 px.
- other files that you might need, depending if you want a vnc or web application. 
- all the files you need to build your program.

It is suggested to take as an example the current images built for the Simphony Organisation. 

vncapp
''''''

For a VNC application, you should build from the vncapp image. Your Dockerfile should have the
following line::

  FROM simphonyproject/ubuntu-14.04-2-vncapp

You also must provide an autostart file that contains the commands to be executed on startup.
Otherwise the desktop would be blank.  The autostart file must be executable by the user
and placed in `/etc/skel/.config/openbox/autostart`.

For example, the Simphony Mayavi image autostarts with the Mayavi2 application by having the
following in its Dockerfile::

  RUN mkdir -p /etc/skel/.config/openbox
  RUN /bin/bash -c 'echo "mayavi2 -style cleanlooks" > /etc/skel/.config/openbox/autostart'
  RUN chmod 755 /etc/skel/.config/openbox/autostart

Note: Further customisation related to the remote access web application should be referred to
github.com/simphony/simphony-remote (pending). 

webapp
''''''

To build a container hosting a web application, the process is similar to the vncapp,
but we will use a different base image, and we need to provide an appropriate startup script.
The wrapper to use is webapp, and is selected as before::

  FROM simphonyproject/ubuntu-14.04-2-webapp

The wrapper is configured to start up, via supervisord, the script `webapp.sh` in the `/`
directory. This script is executed as root, and must start the web application.
There are a few caveats to the web application requirements for export:

- It must listen on port 6081. An internal nginx will reverse proxy it to port 8888
- Note that nginx will _not_ perform any URL rewriting, so the application
  must be able to deal with the full URL. In general this is provided as an option
  `base url`. A common gotcha for this is to have an application that does not
  add the base url to its links, returning a front page that works, but can't be
  navigated because all links are based on `/`. Your application must support
  appropriate links with the specified base url.
- Note also that the container nginx is reverse proxying the request to your
  application, so your application will see requests coming from nginx. This
  might have consequences depending on how your application is designed.

The ``webapp.sh``, and thus your application, will be started as root with HOME set as `/root`
If you want to run as user (recommended) you have to export HOME to the appropriate
path, and change to the specified user (e.g. using sudo or the appropriate
options of your application) inside the `webapp.sh` script.

Common
''''''

At the time of writing, you may add labels to improve the visual aspect of your image.
The following labels are defined:

- ``eu.simphony-project.docker.ui_name``: The label that will be used as a title name in the UI.
- ``eu.simphony-project.docker.icon_128``: a base64 encoded icon. You don't normally add it 
  yourself as a label. You use the build script to encode an ``icon_128.png`` file for you.
  
To build the image, run the ``build_docker.sh`` script on the directory 
containing the Dockerfile. The ``icon_128.png`` file is the icon that the application
will have in simphony-remote. It must be a 128x128 PNG image.

Verification and Debug
''''''''''''''''''''''

You can test vnc images directly by using the ``test_novnc_directly.sh`` script.

If something goes wrong, use the following command to enter into the container::

    docker run -it bash container_id
    
and try to start the application manually, or check the logs in /var/log.

Legacy images
-------------

These images available on Docker hub are all legacy and should not be used:

    - simphonyproject/ubuntu-14.04-remote
    - simphonyproject/ubuntu-12.04-remote
    - simphonyproject/ubuntu-14.04-webapp
    - simphonyproject/ubuntu-14.04-vncapp
    - simphonyproject/ubuntu-12.04-vncapp
    - simphonyproject/filetransfer
    - simphonyproject/jupyter
    - simphonyproject/simphonic-mayavi
    - simphonyproject/simphonic-paraview

These images were used with a different github repo layout, that made all images build part of a single
build. The new layout has individual repositories for each application. It was not possible to reuse those
names above (although it would look possible and convenient) because it would have required to change the
repository source associated to each automatic build. This is not possible on docker hub, unless the automatic
build (and thus all associated images) is deleted. Clearly not an option.

As a workaround, new named builds have been created, associated to the new github repos. They are:

    - simphonyproject/ubuntu-14.04-2-webapp
    - simphonyproject/ubuntu-14.04-2-vncapp
    - simphonyproject/ubuntu-12.04-2-vncapp
    - simphonyproject/filemanager
    - simphonyproject/jupyter-notebook
    - simphonyproject/simphony-mayavi
    - simphonyproject/simphony-paraview

As of refactoring of February 21st, these images should be used instead.
