Build Conf File Formatting
--------------------------

Below is a list of different parameters that can be specified in a ``build.conf``
script. They can be set by using ``name=<value>``.

General
~~~~~~~

.. list-table::

    * - Name
      - Description

    * - ``production_dir``
      - Name of directory within used to store the
        production build files. Typically this can be set to ``production``

    * - ``image_prefix``
      - Prefix to add to the created image

    * - ``tag``
      - Tag to add to the created image

    * - ``ssh_required``
      - Indicates whether SSH capabilities will be required by the ``Dockerfile``.
        Can be turned on by setting to ``true``, though switched off by default
        and therefore generally not required by most builds

Base Image Specific
~~~~~~~~~~~~~~~~~~~

.. list-table::

    * - Name
      - Description

    * - ``base_images_dir``
      - Location of the base OS build files. Refers to a folder
        containing both the ``Dockerfile`` and information that will be included in
        the image for the base OS

    * - ``wrappers_dir``
      - Location of the base wrapper build files. Refers to a folder
        containing both the ``Dockerfile`` and information that will be included in
        the image for the base wrapper layer

    * - ``build_base``
      - Defines which base image and wrappers to combine.
        Format is ``base_image_name:wrapper_name``, with multiple entries separated by spaces.
        Important: this line is extracted with a grep, so don't divide it in multiple lines.

Application Image Specific
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::

    * - Name
      - Description

    * - ``app_dir``
      - Location of the application build files. Refers to a folder containing
        both the ``Dockerfile`` and information that will be included in
        the image for the application

    * - ``base_tag``
      - Reference to the tag of the base image that will be used



