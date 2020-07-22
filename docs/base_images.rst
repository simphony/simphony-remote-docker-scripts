Building Base Images
--------------------

Bash scripts to automate the above points are provided in the ``scripts``
directory. Both require a ``build.conf`` file containing instructions for the build. More
information regarding the formatting of these ``build.conf`` files can be found
`here <build_conf_format.rst>`_. Creating the images can be done by the following steps::

    cd simphony-remote-docker-scripts/scripts
    bash create_production_base.sh <path-to>/simphony-remote-docker-base/build.conf

Will create a ``production`` directory with an appropriately formatted  ``Dockerfile`` capable
of building the base image. Next::

    bash build_base.sh <path-to>/simphony-remote-docker-base/build.conf

Will build the Docker image.
