#!/bin/bash
# Start VNC server in Debian proot
# Usage: bash /root/start_vnc.sh
# This script is designed to run inside debian proot

# Kill any existing sessions
pkill -f 'Xvnc :1' 2>/dev/null
pkill -f 'websockify' 2>/dev/null
sleep 1

# Setup VNC
mkdir -p /root/.config/tigervnc /root/.vnc
echo 'xfce4-session &' > /root/.vnc/xstartup
chmod +x /root/.vnc/xstartup

# Set password if not exists
if [ ! -f /root/.vnc/passwd ]; then
    echo 'password' | /usr/bin/vncpasswd -f > /root/.vnc/passwd
    chmod 600 /root/.vnc/passwd
fi

echo "🐧 Starting VNC server..."
/usr/bin/Xvnc :1 -geometry 1280x720 -depth 24 -localhost yes -alwaysshared -PasswordFile /root/.vnc/passwd &
sleep 2

echo "🌐 Starting WebSocket proxy..."
websockify --web /usr/share/novnc 6080 localhost:5901 &
sleep 2

echo "✅ VNC server running on :1 (port 5901)"
echo "✅ WebSocket running on port 6080"
echo "📱 Open LinxGo → Desktop to view your Linux Desktop"
echo ""
echo "To stop VNC, run: pkill -f 'Xvnc :1' && pkill -f 'websockify'"
