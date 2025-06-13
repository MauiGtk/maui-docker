FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /mauienv

# set environment variable/path
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# install GtkSharp
RUN git clone https://github.com/GtkSharp/GtkSharp.git
WORKDIR /mauienv/GtkSharp
RUN sed -i 's/"8.0.100", "8.0.200"}/"8.0.100", "8.0.200", "8.0.300", "8.0.400"}/g' build.cake  # add missing version bands
RUN dotnet tool restore
  # ^ this allows debugging using the vscode devcontainer extension 
RUN dotnet cake --verbosity=diagnostic --BuildTarget=InstallWorkload
RUN apt update
RUN apt install -y libgtk-3-dev libgtksourceview-4-0
RUN dotnet new install GtkSharp.Template.CSharp

# install MAUI
WORKDIR /mauienv
# as of commit c005e3a -> should build on linux
# note: comment out all following commands, if you maintain your own maui(-linux) folder as a container volume:
RUN git clone https://github.com/lytico/maui
WORKDIR /mauienv/maui

# make sure only include Gtk platform
# see also https://github.com/lytico/maui/blob/6ef7f0c066808ea0d4142812ef4d956245e6a711/.github/workflows/build-gtk.yml#L34-L36
RUN sed -i 's/_IncludeGtk></_IncludeGtk>true</g' Directory.Build.Override.props
RUN sed -i 's/_IncludeWindows>true</_IncludeWindows></g' Directory.Build.Override.props
RUN sed -i 's/_IncludeTizen>true</_IncludeTizen></g' Directory.Build.Override.props
RUN sed -i 's/_IncludeAndroid>true</_IncludeAndroid></g' Directory.Build.Override.props
RUN sed -i 's/_IncludeIos>true</_IncludeIos></g' Directory.Build.Override.props
RUN sed -i 's/_IncludeMacCatalyst>true</_IncludeMacCatalyst></g' Directory.Build.Override.props
RUN sed -i 's/_IncludeMacOS>true</_IncludeMacOS></g' Directory.Build.Override.props
 
# RUN dotnet workload restore
RUN dotnet build Microsoft.Maui.BuildTasks.slnf
RUN dotnet build Microsoft.Maui.Gtk.slnf
RUN apt clean
WORKDIR /mauienv/maui/src/Controls/samples/Controls.Sample

# on the local terminal type:
# xhost + & docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -t maui-env dotnet run --framework net8.0-gtk & xhost -
# alternatively, you could omit the xhost commands and attach a VS Code instance to the container and run it there.

