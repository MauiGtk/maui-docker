FROM mcr.microsoft.com/dotnet/sdk:8.0

# vscode is just the default value, use docker build with the argument "--build-arg USERNAME=$USER"
ARG USERNAME=vscode
ENV USERNAME=$USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /mauienv
RUN chown $USERNAME:$USERNAME /mauienv
USER $USERNAME

WORKDIR /mauienv
COPY  launch.json .vscode/launch.json
COPY tasks.json .vscode/tasks.json
# TODO: add .vs-code volume

# set environment variable/path
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# install GtkSharp
RUN git clone https://github.com/GtkSharp/GtkSharp.git
WORKDIR /mauienv/GtkSharp
RUN sed -i 's/"8.0.100", "8.0.200"}/"8.0.100", "8.0.200", "8.0.300", "8.0.400"}/g' build.cake  # add missing version bands
RUN dotnet tool restore
  # ^ this allows debugging using the vscode devcontainer extension 
RUN dotnet cake --verbosity=diagnostic --BuildTarget=PackageWorkload
# need elevated permissions to install GtkSharp workload and gtk3
USER root
RUN dotnet tool restore
RUN dotnet cake --verbosity=diagnostic --BuildTarget=InstallWorkload
RUN apt update
RUN apt install -y libgtk-3-dev libgtksourceview-4-0
RUN dotnet new install GtkSharp.Template.CSharp
USER $USERNAME

# ___ 1st Option: Persistent Volume Share on Local Host with Bare Docker Setup ___
# if you want to maintain a maui folder locally, mapped as a container volume to persist changes done in the container,
# git clone https://github.com/lytico/maui in the maui-docker folder and make sure it is mounted everytime you run the container, 
# using the docker run -v option or VS Code with devcontainer extension that is provided in this repo. further instructions below:
RUN echo 'cd maui \n sed -i "s/>true<\/_Include/><\/_Include/g" Directory.Build.Override.props.in \n sed -i "s/_IncludeGtk></_IncludeGtk>true</g" Directory.Build.Override.props.in \n cp Directory.Build.Override.props.in Directory.Build.Override.props \n dotnet build Microsoft.Maui.BuildTasks.slnf \n dotnet build Microsoft.Maui.Gtk.slnf \n apt clean \n echo "done building maui; now  cd maui/src/Controls/samples/Controls.Sample  and  dotnet run --framework net8.0-gtk"' > build-gtk-platform.sh ; chmod a+x build-gtk-platform.sh
# 1. open a terminal; cd into the maui-docker folder and (re)build the docker image with the command docker build -t maui-env .
# 2. start the container using:
# xhost + & docker run -it --rm -e DISPLAY=$DISPLAY -v "$HOME/maui-docker/maui:/mauienv/maui" -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env bash
# 3. inside the container start ./build-gtk-platform.sh

# ___ 2nd Option: VS Code from the Local Linux (or WSL) ___
# 1. In the repo folder type "code ." to start VS Code and open the current folder
# 2. Install the Devcontainer extension
# 3. F1 "Devcontainer: Reopen in Container"
# 4. Hit Ctrl-Shift-D and launch the Controls.Sample in the upper-left corner VS Code's application window.

# ___ 3rd Option: Read-Only Setup with MAUI Build Already as Part of the Container Image __
# RUN git clone https://github.com/lytico/maui
# WORKDIR /mauienv/maui
# # make sure to only include Gtk platform using sed
# # ( see also https://github.com/lytico/maui/blob/6ef7f0c066808ea0d4142812ef4d956245e6a711/.github/workflows/build-gtk.yml#L34-L36 )
# RUN sed -i 's/>true<\/_Include/><\/_Include/g' Directory.Build.Override.props*
# RUN sed -i 's/_IncludeGtk></_IncludeGtk>true</g' Directory.Build.Override.props*
# RUN dotnet build Microsoft.Maui.BuildTasks.slnf
# RUN dotnet build Microsoft.Maui.Gtk.slnf
# RUN apt clean
# WORKDIR /mauienv/maui/src/Controls/samples/Controls.Sample
# on the local terminal type:
# xhost + & docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env dotnet run --framework net8.0-gtk & xhost -
# alternatively, you could omit the xhost commands and attach a VS Code instance to the container and run it there.

