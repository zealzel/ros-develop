#!/bin/bash
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$script_dir/../../scripts/utils.sh"
UBUNTU_CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d"=" -f2)

if [[ "$UBUNTU_CODENAME" == "focal" ]]; then
  echo "Ubuntu 20.04 detected. Set ROSDISTRO to galactic."
  ROSDISTRO="galactic"
  ORIGINAL_IMAGE="[488d07354c8b92592c3c0e759b0f4730dce21dce]ubuntu-20.04.5-preinstalled-server-arm64+raspi.img.xz"
  IMAGE_DOWNLOAD_SITE=
elif [[ "$UBUNTU_CODENAME" == "jammy" ]]; then
  echo "Ubuntu 22.04 detected. Set ROSDISTRO to humble."
  ROSDISTRO="humble"
  ORIGINAL_IMAGE="[1ebe853ca69ce507a69f97bb70f13bc1ffcfa7a2]ubuntu-22.04.2-preinstalled-server-arm64+raspi.img.xz"
  IMAGE_DOWNLOAD_SITE=
else
  echo "Ubuntu $UBUNTU_CODENAME is not supported"
  exit 1
fi

echo "The original image: $ORIGINAL_IMAGE"
echo "The original image download site: $IMAGE_DOWNLOAD_SITE"

WORKSPACE="zbotartic_ws"
echo "UBUNTU_CODENAME=$UBUNTU_CODENAME"
echo "ROSDISTRO=$ROSDISTRO"
echo "WORKSPACE=$WORKSPACE"
../../ros2/scripts/prepare_ros2_workspace.sh -u $UBUNTU_CODENAME -r $ROSDISTRO -w $WORKSPACE

# Added temporarily for testing
../ros2/scripts/install_mppi_controllers.sh -r $ROS_DISTRO -w $WORKSPACE

echo
echo ====================================================================
echo Create udev rules
echo ====================================================================
./create_udev.sh

echo ===============================================
echo Install packages from apt
echo ===============================================
../../scripts/install_from_apt.sh $WORKSPACE $ROSDISTRO "ros_packages.sh" "false"

# Temporarily. Needed by usb_cam. Need to be handled more systematically
sudo apt install python3-pip python3-websocket -y
../../scripts/install_python_packages.sh pydantic

echo
echo ===============================================
echo Build/Install robots packages from source
echo ===============================================
source "/opt/ros/${ROSDISTRO}/setup.bash" && ../../scripts/install_from_source.sh -w $WORKSPACE -v "$script_dir/zbot_artic_$ROSDISTRO.repos"

echo ======== Env Variables ========
if [[ "$ROS_DISTRO" == "galactic" ]]; then
    append_bashrc "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
elif [[ "$ROS_DISTRO" == "humble" ]]; then
    append_bashrc "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
fi
append_bashrc "export ROBOT_TYPE=artic"
echo
echo "Do you want to add sourcing of $WORKSPACE on your ~/.bashrc?"
echo -n "Yes [y] or No [n]: "
read reply
WORKSPACEPATH="$HOME/$WORKSPACE"
if [[ "$reply" == "y" || "$reply" == "Y" ]]; then
    append_bashrc "source ${WORKSPACEPATH}/install/setup.bash"
else
    echo
    echo "Remember to run $ source ${WORKSPACEPATH}/install/setup.bash every time you open a terminal."
fi
