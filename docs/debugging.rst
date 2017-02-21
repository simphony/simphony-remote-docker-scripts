Test remote access of an image locally
--------------------------------------

If you are on Linux, you may use a script provided ``./scripts/test_noVNC_directly.sh``
directly in your terminal::

  $ ./scripts/test_noVNC_directly.sh image_name ./scripts/test_env_file test

On Mac OS X, you should run the above script in your docker VM.
You should clean up the started container once you finish testing.

Running built images on the command-line
----------------------------------------

The docker images built have a default entrypoint for the use of the remote access web application.
Therefore you will get an error message if you try to run it interactively on the command-line::

  $ docker run -it image_name bash
  Cannot obtain USER variable

Instead you should override the entrypoint::

  $ docker run -it --entrypoint=/bin/bash image_name

Running the docker image from the command-line is often useful for debugging.


