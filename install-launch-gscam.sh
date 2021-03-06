## Install gscam

# Install GStreamer plugins (needed for H.264 encoding etc).
echo "${green}Installing GStreamer plugins...${reset}"
sudo apt-get install -y gstreamer1.0-plugins-bad

# install libwebcam command line tool, and disable autofocus and autoexposure
sudo apt-get install -y uvcdynctrl
#  disable autofocus and set focus to infinity
#uvcdynctrl -s "Focus, Auto" 0
#uvcdynctrl -s "Focus (absolute)" 0
#  set auto exposure to 'Manual Mode' and set exposure to default value
#uvcdynctrl -s "Exposure, Auto" 1
#uvcdynctrl -s "Exposure (Absolute)" 156

# Installing gscam ROS package and its dependencies.
echo "${green}Starting installation of gscam ROS package...${reset}"
echo "Installing dependencies..."
sudo apt-get install -y libgstreamer1.0-dev gstreamer1.0-tools libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev libyaml-cpp-dev

cd $HOME
# Install gscam dependencies.
sudo apt-get install -y ros-kinetic-camera-info-manager ros-kinetic-camera-calibration-parsers ros-kinetic-image-transport

echo "Cloning gscam sources..."
git clone https://github.com/ros-drivers/gscam.git
cd gscam
# Create symlink to catkin workspace.
ln -s $HOME/gscam $CATKIN_WS/src/

cd $CATKIN_WS
catkin_make
source /devel/setup.bash

## Use gscam
# Check if camera is connected properly
ls /dev/video*
# Launch core of ROS
roscore
# Launch gscam node. Change device=/dev/video* to the appropriate value based on command ls /dev/video*
# (e.g. if you have /dev/video1 /dev/video2, then /dev/video1 refers to RGB value and /dev/video2 refers to depth ... i think)
roscd gscam
export GSCAM_CONFIG="v4l2src device=/dev/video0 ! videoscale ! video/x-raw-yuv,width=640,height=320 ! ffmpegcolorspace ! video/x-raw-rgb"
rosrun gscam gscam
# To see image raw. Click '/camera/image_raw' in pop-up window
rqt_image_view

## Troubleshooting
# Check if gscam is installed
  # rosdep install gscam
  # rosmake gscam
# List topics
  # rostopic list

