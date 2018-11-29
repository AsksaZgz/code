 ### X11 Installation - 1811231159
yum install -y xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps

vi /etc/ssh/sshd_config

### X11Forwarding yes
### X11DisplayOffset 10

systemctl restart sshd

#NO# yum install xauth
#NO# yum install xorg
#NO# yum install openbox
