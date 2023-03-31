## Quickly build envirnoment for ROS1/ROS2 developement.

Please git clone this repo into you developement envirnoment.

## Install ROS2

### For the virtual machine envirnoment

The host machine is MacOS, and the virtual machine is Ubuntu 20.04 installed through Parallels.

#### Ubuntu 20.04

The image used is ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz

```bash
# in your virtual machine
$ git clone https://github.com/zealzel/ros-develop.git $HOME
$ cd $HOME/ros-develop/scripts

# install ROS2
$ ./install_ros2.sh --ROSDISTRO=galactic --ROS_INSTALL_TYPE=desktop --APPEND_SOURCE_SCRIPT_TO_BASHRC=true
or
$ ./install_ros2.sh -r galactic -i desktop -a true

# install colcon
$ ./install_colcon.sh --ROSDISTRO=galactic
```

```bash

```
