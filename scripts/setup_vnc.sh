#!/bin/bash
# إعداد Debian + VNC في Termux
# شغّل هذا في Termux خطوة بخطوة

echo "📦 تثبيت proot-distro..."
pkg install proot-distro -y

echo "🐧 تثبيت Debian..."
proot-distro install debian

echo "✅ جاري إعداد Debian مع VNC..."
proot-distro login debian -- bash -c '
  apt update && apt install -y tigervnc-standalone-server xfce4 xfce4-goodies novnc websockify
  mkdir -p ~/.vnc
  echo "xfce4-session &" > ~/.vnc/xstartup
  chmod +x ~/.vnc/xstartup
  echo "✅ تم تثبيت كل شي!"
  echo ""
  echo "الخطوة التالية: شغّل VNC"
  echo "vncserver :1 -geometry 1280x720 -localhost yes"
  echo "websockify --web /usr/share/novnc 6080 localhost:5901"
'

echo ""
echo "🎉 الإعداد اكتمل!"
