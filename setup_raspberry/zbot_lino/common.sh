
function install_rplidar {
  sudo apt install -y ros-"$ROS_DISTRO"-rplidar-ros
  cd /tmp
  wget https://raw.githubusercontent.com/allenh1/rplidar_ros/ros2/scripts/rplidar.rules
  sudo cp rplidar.rules /etc/udev/rules.d/
}

function install_realsense {
  # sudo apt install -y ros-"$ROS_DISTRO"-realsense2-camera
  # Install latest Intel® RealSense™ SDK 2.0
  sudo apt install -y ros-"$ROS_DISTRO"-librealsense2-*
  # Install Intel® RealSense™ ROS2 wrapper
  sudo apt install -y ros-"$ROS_DISTRO"-realsense2-*
  cd /tmp
  wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules
  sudo cp 99-realsense-libusb.rules /etc/udev/rules.d
}
