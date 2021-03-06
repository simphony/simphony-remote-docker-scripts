SimPhoNy Remote Docker CHANGELOG
================================

Release 0.6.0.dev0
-------------------

Features
~~~~~~~~
- Fix to image tags (#1)
- Handling ssh keys for commands that need passwords (#1)
- Documentation update for handling ssh commands (#1)

Release 0.5.0/0.5.1
-------------------

Features
~~~~~~~~

- Documentation updates (#45, #49, #50)
- Easier script to build without deploying (#48)
- Added support for LIGGHTS in both mayavi and paraview. (#51)
  This PR also removes the personalized simphony-framework build, and instead checks out the one
  from the repo.
- Pinned simphony-framework version to 0.3.0 (#52)
- (0.5.1) Fixed missing icon (#54)

Release 0.4.0
-------------

Features
~~~~~~~~

- Added support for accepted environment variable description through labels. (#35, #36)
- Added "type" label (#32)
- Allowed for VNC resolution setup (#34)
- Removed Close button. (#38)

Fixes
~~~~~

- Fixes simphonic-mayavi problem generated by conflict with setuptools 28.0 (#42)
- Fixes skel management that resulted in invalid home directory if a volume was mounted
  there (#39, #40)


Release 0.3.0
-------------

Features
~~~~~~~~

- Supports two separated docker base images, one for XWindows applications (-vncapp) and
  one for web applications (-webapp). This deprecates the old base image (-remote)
- Added `filetransfer` and `jupyterhub` images to provide a File navigator and a jupyter notebook
- Reorganization of layout and build scripts.
- Unified development vs deployment approach to images building. Now the images are always
  prepared in the `production` directory, and built with the build scripts from this directory.
- Added documementation about the setup of the production, docker hub automatic build.

Release 0.2.0
-------------

Features
~~~~~~~~

- Support simphony-remote version 0.1.0 and 0.2.0 (#7)

Fixes
~~~~~

- Start nginx outside and before supervisord (#6)
- Added script for manual testing (#3, #10)


Release 0.1.1
-------------

Fixes
~~~~~

- Simplify image names: simphony-framework-* -> simphonic-*
- Rename ubuntu-*-base to ubuntu-*-remote
- Fix simphony-openfoam import for the simphonic-mayavi image
- Added README for every image


Release 0.1.0
-------------

Features
~~~~~~~~

- Added ubuntu-12.04-base and ubuntu-14.04-base as base ubuntu images with remote access support
- Added simphony-framework-mayavi and simphony-framework-paraview images with remote access support
- Added build scripts for development and for creating the Docker context for DockerHub auto build
