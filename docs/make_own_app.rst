Making your own Simphony-Remote Applications
--------------------------------------------

To build your own image, you need to create an application directory (which is normally a github repo).
Inside this directory, you will need:

- a ``build.conf`` file (formatting information can be found `here <build_conf_format.rst>`_)
- a directory named like the image (e.g. ``myprogram``).

Inside the ``myprogram`` directory, you must have:

- a ``Dockerfile``
- optionally: a ``icon_128.png`` file containing the icon in 128x128 px.
- other files that you might need, depending if you want a VNC or web application.
- all the files you need to build your program.

Additionally, you will have needed to have access to a previously created ``vncapp`` or ``webapp``
base image. These can be created using the following `instructions <docker_base.rst>`_.

VNC Application
'''''''''''''''

For a VNC application, you should build from the ``vncapp`` image. Your ``Dockerfile`` should have the
following line::

  FROM simphonyproject/ubuntu-18.04-vncapp

You also must provide an ``autostart`` file that contains the commands to be executed on startup.
Otherwise the desktop would be blank.  The autostart file must be executable by the user
and placed in ``/etc/skel/.config/openbox/autostart``.

For example, the Simphony Mayavi image autostarts with the Mayavi2 application by having the
following in its Dockerfile::

  RUN mkdir -p /etc/skel/.config/openbox
  RUN /bin/bash -c 'echo "mayavi2 -style cleanlooks" > /etc/skel/.config/openbox/autostart'
  RUN chmod 755 /etc/skel/.config/openbox/autostart

The ``autostart`` file can also be used to perform any authentication of commercial software,
using a license file or key. Any license that has been defined during the creation of an
``ApplicationPolicy`` in SimPhoNy-Remote will be available as the ``APP_LICENSE``
variable in the Docker container environment. Developers may then use this reference to
authenticate any software during the application's runtime, avoiding the need to 'hard-code'
this into the Docker image.

Web Application
'''''''''''''''

To build a container hosting a web application, the process is similar to the ``vncapp``,
but we will use a different base image, and we need to provide an appropriate startup script.
The wrapper to use is ``webapp``, and is selected as before::

  FROM simphonyproject/ubuntu-18.04-webapp

The wrapper is configured to start up, via ``supervisord``, the script ``webapp.sh`` in the ``/``
directory. This script is executed as root, and must start the web application.
There are a few caveats to the web application requirements for export:

- It must listen on port 6081. An internal nginx will reverse proxy it to port 8888
- Note that nginx will _not_ perform any URL rewriting, so the application
  must be able to deal with the full URL. In general this is provided as an option
  ``base url``. A common gotcha for this is to have an application that does not
  add the base url to its links, returning a front page that works, but can't be
  navigated because all links are based on ``/``. Your application must support
  appropriate links with the specified base url.
- Note also that the container nginx is reverse proxying the request to your
  application, so your application will see requests coming from nginx. This
  might have consequences depending on how your application is designed.

The ``webapp.sh``, and thus your application, will be started as root with HOME set as ``/root``
If you want to run as user (recommended) you have to export HOME to the appropriate
path, and change to the specified user (e.g. using sudo or the appropriate
options of your application) inside the ``webapp.sh`` script.

Common Features
'''''''''''''''

These features can be included in both VNC and Web application Dockerfiles.

Including private repositories
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the Dockerfile that creates the application includes cloning private repositories, then the
``Dockerfile-ssh.template`` file included in the ``simphony-remote-docker/scripts`` directory
contains some example script in order to perform this task. As of writing, the recommended guidelines
for including secrets (such as RSA private keys) in Docker images involves the use of
`Docker BuildKit <https://docs.docker.com/develop/develop-images/build_enhancements/>`_.

In order to indicate that the BuildKit ssh functionality will be required, please include
``ssh_required=true`` in the ``build.conf`` script. All ``RUN`` commands in the app Dockerfile
that require ssh authentication must then be mounted appropriately::

    RUN --mount=type=ssh <command> <options>

Image Appearance
~~~~~~~~~~~~~~~~

At the time of writing, you may add labels to improve the visual aspect of your image.
The following labels are defined:

- ``eu.simphony-project.docker.ui_name``: The label that will be used as a title name in the UI.
- ``eu.simphony-project.docker.icon_128``: a base64 encoded icon that the application
  will have in the Simphony-Remote user session. NOTE: You don't normally add it
  yourself as a label, but rather use the build scripts to encode an ``icon_128.png`` file for you.

If any file named ``icon_128.png`` exists in the application directory, this will be automatically
encoded into the production files by the ``create_production_app.sh`` script. This file must contain
a 128x128 pixel PNG image. An example is provided in the ``simphony-remote-docker-mayavi/simphony-mayavi``
folder.

Building Application Images
'''''''''''''''''''''''''''

Once the application scripts are ready, you can perform the build be using the scrips available in the
``simphony-remote-docker/scripts`` directory. To generate the usable Docker layout, follow these steps::

    cd <simphony-remote-docker>/scripts
    bash create_production_app.sh <path-to-application>/build.conf

This generates the ``production`` directory containing the buildable ``Dockerfile`` scripts and
the associated files. The last step will generate the docker image from the production files::

    bash build_app.sh <path-to-application>/build.conf

IMPORTANT: if you deploy new images, do ensure that containers from the old images are deleted,
otherwise the user will continue to use the old container instead of creating a new one from
the new images.  To do so, check ``docker ps -a`` and then do ``docker rm`` of all the obsolete containers.

Verification and Debug
''''''''''''''''''''''

You can test vnc images directly by using the ``test_novnc_directly.sh`` script.

If something goes wrong, use the following command to enter into the container::

    docker run -it bash container_id

and try to start the application manually, or check the logs in ``/var/log``.
