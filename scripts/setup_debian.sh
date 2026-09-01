#!/bin/bash
# Setup Debian Linux for LinxGo
# Run this inside Termux after installing proot-distro

set -e

echo "🐧 Setting up Debian for LinxGo..."

# Update system
apt update && apt upgrade -y

# Install essential packages
apt install -y \
    sudo \
    wget \
    curl \
    git \
    vim \
    nano \
    htop \
    neofetch \
    bash-completion

# Install desktop environment (XFCE4 - lightweight)
apt install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    mousepad \
    ristretto \
    thunar

# Install VNC server
apt install -y \
    tigervnc-standalone-server \
    tigervnc-common

# Install noVNC and websockify
apt install -y \
    novnc \
    websockify

# Install Firefox ESR (lightweight browser)
apt install -y \
    firefox-esr

# Install VS Code (code-oss)
wget -qO - https://gitlab.com/paulcarroty/vsc-deb-rpm-repo/raw/master/pub.gpg | apt-key add -
echo "deb https://paulcarroty.gitlab.io/vsc-deb-rpm-repo/debs/ vsc main" > /etc/apt/sources.list.d/vsc.list
apt update && apt install -y code-oss || echo "VS Code install skipped"

# Setup VNC
mkdir -p ~/.vnc
echo "xfce4-session &" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# Create start script
cat > ~/start_vnc.sh << 'EOF'
#!/bin/bash
# Kill existing sessions
vncserver -kill :1 2>/dev/null || true

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 24 -localhost yes -alwaysshared

# Start websockify (WebSocket proxy)
nohup websockify -D 6080 localhost:5901 > /tmp/websockify.log 2>&1 &

echo "✅ VNC started on :1 (port 5901)"
echo "✅ WebSocket proxy on port 6080"
echo "📱 Open LinxGo and connect!"
EOF
chmod +x ~/start_vnc.sh

# Create stop script
cat > ~/stop_vnc.sh << 'EOF'
#!/bin/bash
vncserver -kill :1 2>/dev/null || true
pkill -f websockify 2>/dev/null || true
echo "⏹️ VNC stopped"
EOF
chmod +x ~/stop_vnc.sh

echo ""
echo "==================================="
echo "✅ Debian setup complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo "1. Run: vncpasswd  (set your VNC password)"
echo "2. Run: ~/start_vnc.sh"
echo "3. Open LinxGo on your Android device"
echo ""
