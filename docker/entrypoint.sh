#!/bin/bash
set -e

export LROSE_INSTALL_DIR=/opt/lrose
export PROJ_DIR=/opt/titan/projDir
export DATA_DIR=/data/titan
export PATH="${LROSE_INSTALL_DIR}/bin:${PROJ_DIR}/system/scripts:${PROJ_DIR}/ingest/scripts:${PROJ_DIR}/titan/scripts:${PROJ_DIR}/display/scripts:${PATH}"

# Start virtual display
Xvfb :1 -screen 0 1280x1024x24 &
export DISPLAY=:1
sleep 1

# Start window manager
fluxbox &
sleep 1

# Start VNC server so you can view the display from Windows
x11vnc -display :1 -nopw -listen 0.0.0.0 -xkb -forever &

echo "TITAN Bulgaria - VNC available on port 5900"
echo "Connect with a VNC client to localhost:5900"

# Start TITAN processes
cd ${PROJ_DIR}/system/scripts
./start_all

# Keep container alive
tail -f /dev/null
