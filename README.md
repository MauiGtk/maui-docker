# maui-docker -- a Docker container for reproducably setting up a MAUI development environment

In defailt mode, this is intended to demonstrate issues with the [MAUI](https://github.com/lytico/maui) Gtk platform and not 
for active development as changes in the container would get lost on a `docker build`. But there is a devcontainer setup to have the maui folder mounted as a docker volume to persist changes to the codebase (see "Optional Setup with Persistent Volume Share on Local Host" section in the Dockerfile).

## How to use

### Require

- [Docker](https://www.docker.com) or [Podman](https://podman.io)

### Build

You can choose to use github packages or use the source.

#### From GitHub Packages

```sh
# Pull Docker package
docker pull ghcr.io/MauiGtk/maui-docker:main

# Build Docker environment
xhost +  # allow container to use the X display of the host
# replace the 'dotnet ...' command with 'bash' to have a look inside the container:
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t ghcr.io/mauigtk/maui-docker:main dotnet run --framework net8.0-gtk
xhost -  # restrict display access again
```

> [!note]
> If you want to use a specific tag, change `:sha256-` to `@sha256:`. (See also [#3](https://github.com/MauiGtk/maui-docker/issues/3))
> 
> ❌: `ghcr.io/mauigtk/maui-docker:sha256-2dcf2050c0c9443706675d278f8e73dd8ab08d625b48a263238798f235bcd7cb` 
> ✅: `ghcr.io/mauigtk/maui-docker@sha256:2dcf2050c0c9443706675d278f8e73dd8ab08d625b48a263238798f235bcd7cb`

#### From Sources

```sh
# git clone
git clone https://github.com/MauiGtk/maui-docker.git
cd maui-docker

# Build Docker package
docker build -t maui-env .

# Build Docker environment
xhost +  # allow container to use the X display of the host
# replace the 'dotnet ...' command with 'bash' to have a look inside the container:
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env dotnet run --framework net8.0-gtk
xhost -  # restrict display access again
```

### 

Alternatively, use Visual Studio Code to handle the display and have a deeper look at the MAUI sources:
1. Start VS Code in a new bash outside the container with `code .`,
1. then install VS Codes 'Dev Containers' and 'Docker' extension. After that, 
1. in the 'Containers' item of side panel start the 'maui-env' container and right click / attach it to VS Code, 
1. then click the generated container name at the top. 
1. In the newly opened Code window, wait a few seconds until VS Code is setup in the container.

Finally open folder /mauienv/maui/ and enter these commands in VS Codes terminal window:

```sh
cd /mauienv/maui/src/Controls/samples/Controls.Sample
dotnet run --framework net8.0-gtk
```

... or simply hit <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd> and launch the sample by pressing the play button.

![Controls.Sample](https://raw.githubusercontent.com/MauiGtk/maui-docker/d77cd672b4586fcfbe5a9aea89dff0ea8cfee3f2/pics/ControlsSample.png)

Also have a look at

```sh
cd ../Controls.Sample.Gtk
cp ../Controls.Sample/Resources/Images/calculator.png ./dotnet_bot.png  # someone forgot to git add the image
dotnet run
```

![Controls.Sample.Gtk](https://raw.githubusercontent.com/MauiGtk/maui-docker/d77cd672b4586fcfbe5a9aea89dff0ea8cfee3f2/pics/ControlsSampleGtk.png)
