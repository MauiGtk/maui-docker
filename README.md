# maui-docker -- a Docker container for reproducably setting up a MAUI development environment

This is intended to demonstrate issues with [MAUI](https://github.com/jsuarezruiz/maui-linux) and not 
for active development as changes in the container would get lost on a `docker build`.

Note: You need to have [Docker](https://docs.docker.com/engine/install/ubuntu/) installed and set up 
on your system to use this.

After git-cloning and cd into the repo, build the image:

    docker build -t maui-env .

This will build MAUI along with GtkSharp already. Then start the container using (this can take a minute to start up):

    xhost +
    docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env dotnet run --framework net8.0-gtk
    xhost -

Alternatively, use Visual Studio Code to handle the display: Start VS Code in a new bash outside the container with `code .`,
then install VS Codes 'Dev Containers' and 'Docker' extension. After that, right click the gtksharp-env
container in the Docker side panel and attach it to VS Code, then click the generated container name at
the top. In the newly opened Code window, wait a few seconds until VS Code is setup in the container,
then open folder /mauienv/maui-linux/ and enter these commands in VS Codes terminal window:

    cd /mauienv/maui-linux/src/Controls/samples/Controls.Sample
    dotnet run --framework net8.0-gtk

Also have a look at

    cd ../Controls.Sample.Gtk
    cp ../Controls.Sample/Resources/Images/calculator.png ./dotnet_bot.png  # someone forgot to git add the image
    dotnet run

