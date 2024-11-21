# maui-docker -- a Docker container for reproducably setting up a MAUI development environment

This is intended to demonstrate issues with [MAUI](https://github.com/jsuarezruiz/maui-linux) and not 
for active development as changes in the container would get lost on a `docker build`.

Note: You need to have [Docker](https://docs.docker.com/engine/install/ubuntu/) installed and set up 
on your system to use this.

After git-cloning and cd into the repo, build the image:

    docker build -t maui-env .

This will build MAUI along with GtkSharp already. Then visit the container using:

    docker run -i --rm -t maui-env bash

Visual Studio Code is encouraged: Install VS Codes 'Dev Containers' extension, then right click the 
maui-env container and attach it to VS Code. Wait a few seconds until VS Code is setup in the
container, then go to the Run & Debug tab and choose a launch option.
