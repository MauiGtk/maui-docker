# maui-docker -- a Docker container for reproducably setting up a MAUI development environment

This is intended to demonstrate issues with [MAUI](https://github.com/jsuarezruiz/maui-linux) and not 
for active development as changes in the container would get lost on a `docker build`.
If you really want to tinker with the maui codebase, `git clone https://github.com/jsuarezruiz/maui-linux` 
(or clone you own maui-linux fork, in case you eventually come to the point where you want to create 
substantial pull requests) right after cloning and cd into this maui-docker repo and make sure to 
always add the `-v "$(pwd)"/maui-linux:/mauienv/maui-linux` parameter in your `docker run` command.

Note: You need to have [Docker](https://docs.docker.com/engine/install/ubuntu/) installed and set up 
on your system to use this.

After git-cloning and cd into the repo, build the image:

    docker build -t maui-env .

This will build MAUI along with GtkSharp already. Then start the container using (this can take a minute to start up):

    xhost +  # allow container to use the X display of the host
    # replace the 'dotnet ...' command with 'bash' to have a look inside the container:
    docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env dotnet run --framework net8.0-gtk
    # or alternatively, if you have cloned the maui-linux folder manually outside the container and want to map it as a volume:
    docker run -it --rm -v "$(pwd)"/maui-linux:/mauienv/maui-linux -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env dotnet run --framework net8.0-gtk    
    xhost -  # restrict display access again

Alternatively, use Visual Studio Code to handle the display and have a deeper look at the MAUI sources: 
Start VS Code in a new bash outside the container with `code .`,
then install VS Codes 'Dev Containers' and 'Docker' extension. After that, 
in the 'Containers' item of side panel start the 'maui-env' container and right click / attach it to VS Code, 
then click the generated container name at the top. 
In the newly opened Code window, wait a few seconds until VS Code is setup in the container,
then open folder /mauienv/maui-linux/ and enter these commands in VS Codes terminal window:

    cd /mauienv/maui-linux/src/Controls/samples/Controls.Sample
    dotnet run --framework net8.0-gtk

Also have a look at

    cd ../Controls.Sample.Gtk
    cp ../Controls.Sample/Resources/Images/calculator.png ./dotnet_bot.png  # someone forgot to git add the image
    dotnet run
