# maui-docker -- a Docker container for reproducably setting up a MAUI development environment

In defailt mode, this is intended to demonstrate issues with the [MAUI](https://github.com/lytico/maui) Gtk platform and not 
for active development as changes in the container would get lost on a `docker build`. But there is a devcontainer setup to have the maui folder mounted as a docker volume to persist changes to the codebase (see "Optional Setup with Persistent Volume Share on Local Host" section in the Dockerfile).

Note 1: You need to have [Docker](https://docs.docker.com/engine/install/ubuntu/) installed and set up 
on your system to use this. Maks sure the docker demon is running:

Note 2: Use the main branch of this repo to have a bare docker-only setup without source code colume mount and VS Code support.

    sudo service docker start

After git-cloning and cd into the repo, build the image:

    docker build -t maui-env .

Note: If you are working with Windows + WSL and the build hangs at a certain step, it often helps to restart the WSL with "wsl --shutdown" in a Powershell window.

This branch is for Visual Studio Code to handle the display and persistent maui source code volume, in case you want to contribute:
* Start VS Code in a new bash outside the container with `code .`,
* then install VS Codes 'Dev Containers' and 'Docker' extension. After that, 
* F1 click "Dev Containers: Reopen in Container" (or click "Reopen in Container" if asked in a notification upon subsequent starts of VS Code)
* In the newly opened Code window, wait a few seconds until VS Code is setup in the container.
* Now build maui (TODO: detailed description)

Finally open folder /mauienv/maui/ and enter these commands in VS Codes terminal window:

    cd /mauienv/maui/src/Controls/samples/Controls.Sample
    dotnet run --framework net8.0-gtk

... or simply hit Ctrl-Shift-D and launch the sample by pressing the play button.

![Controls.Sample](https://raw.githubusercontent.com/Thomas-Mielke-Software/maui-docker/d77cd672b4586fcfbe5a9aea89dff0ea8cfee3f2/pics/ControlsSample.png)

Also have a look at

    cd ../Controls.Sample.Gtk
    cp ../Controls.Sample/Resources/Images/calculator.png ./dotnet_bot.png  # someone forgot to git add the image
    dotnet run

![Controls.Sample.Gtk](https://raw.githubusercontent.com/Thomas-Mielke-Software/maui-docker/d77cd672b4586fcfbe5a9aea89dff0ea8cfee3f2/pics/ControlsSampleGtk.png)
