#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z ${NO_MAKE_ROS_MODULES+x} ]; then
    $DIR/make-ros-modules.sh
fi

$DIR/run-roscore.sh > ~/core.log 2>&1 &

sleep 5s  # wait for roscore to run TODO replace with roslaunch

$DIR/run-lidar.sh > ~/lidar.log 2>&1 &
sleep 1

$DIR/run-ballsbot_laser_sensor_front.sh > ~/sensor_front.log 2>&1 &
sleep 5

$DIR/run-ballsbot_laser_sensor_rear.sh > ~/sensor_rear.log 2>&1 &
sleep 1

if [ -z ${NO_DETECTION+x} ]; then
    $DIR/run-ballsbot_detection.sh > ~/detection.log 2>&1 &
    sleep 1
fi

$DIR/run-jupyter.sh

kill %1 2>/dev/null
kill %2 2>/dev/null
kill %3 2>/dev/null
kill %4 2>/dev/null

