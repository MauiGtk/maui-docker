# maui-docker -- a Docker container for reproducably setting up a MAUI development environment

This is intended to demonstrate issues with the [MAUI](https://github.com/jsuarezruiz/maui-linux) Gtk platform and not 
for active development as changes in the container would get lost on a `docker build`. I'm currently working on a devcontainer setup to have the maui folder mounted as a docker volume to persist changes to the codebase.

Note: You need to have [Docker](https://docs.docker.com/engine/install/ubuntu/) installed and set up 
on your system to use this.

After git-cloning and cd into the repo, build the image:

    docker build -t maui-env .

This will build MAUI along with GtkSharp already. Then start the container (which can take a minute) using:

    xhost +  # allow container to use the X display of the host
    # replace the 'dotnet ...' command with 'bash' to have a look inside the container:
    docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env dotnet run --framework net8.0-gtk
    xhost -  # restrict display access again

Alternatively, use Visual Studio Code to handle the display and have a deeper look at the MAUI sources:
* Start VS Code in a new bash outside the container with `code .`,
* then install VS Codes 'Dev Containers' and 'Docker' extension. After that, 
* in the 'Containers' item of side panel start the 'maui-env' container and right click / attach it to VS Code, 
* then click the generated container name at the top. 
* In the newly opened Code window, wait a few seconds until VS Code is setup in the container,
* then open folder /mauienv/maui-linux/ and enter these commands in VS Codes terminal window:

    cd /mauienv/maui-linux/src/Controls/samples/Controls.Sample
    dotnet run --framework net8.0-gtk

![Controls.Sample](https://raw.githubusercontent.com/Thomas-Mielke-Software/maui-docker/d77cd672b4586fcfbe5a9aea89dff0ea8cfee3f2/pics/ControlsSample.png)

Also have a look at

    cd ../Controls.Sample.Gtk
    cp ../Controls.Sample/Resources/Images/calculator.png ./dotnet_bot.png  # someone forgot to git add the image
    dotnet run

![Controls.Sample.Gtk](https://raw.githubusercontent.com/Thomas-Mielke-Software/maui-docker/d77cd672b4586fcfbe5a9aea89dff0ea8cfee3f2/pics/ControlsSampleGtk.png)
