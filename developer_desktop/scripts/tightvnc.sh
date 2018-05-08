#!/bin/bash
# Install tigertvnc server

sudo apt-get -qq -y install tigervnc-standalone-server expect

# Set the vnc password
expect <<EOF
spawn vncserver
expect "Password:"
send "dockerlab\r"
expect "Verify:"
send "dockerlab\r"
expect "Would you like to enter a view-only password (y/n)?"
send "n\r"
expect eof
exit
EOF

# Kill the VNC server that just started
vncserver -kill :1

# configure lubuntu desktop to start when vnc starts
# Assumes lubuntu lxde is installed
mv ~/.vnc/xstartup ~/.vnc/xstartup.orig
echo "#!/bin/sh" > ~/.vnc/xstartup
echo "xrdb $HOME/.Xresources" >> ~/.vnc/xstartup
echo "xsetroot -solid grey" >> ~/.vnc/xstartup
echo "export XKL_XMODMAP_DISABLE=1" >> ~/.vnc/xstartup
#echo "lxterminal &" >> ~/.vnc/xstartup
echo "/usr/bin/lxsession -s LXDE &" >> ~/.vnc/xstartup

# Configure the startup file
cat <<EOF > vncserver.service
[Unit]
Description=Start tightvnc server at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=/bin/su - ubuntu -c "/usr/bin/vncserver -depth 16 -geometry 1280x786 -localhost no :1"

[Install]
WantedBy=multi-user.target
EOF

sudo mv vncserver.service /lib/systemd/system/vncserver.service
sudo systemctl daemon-reload
sudo systemctl enable vncserver.service
sudo systemctl start vncserver.service
