 ### X11 Installation
yum install -y xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps

vi /etc/ssh/sshd_config

### X11Forwarding yes

systemctl restart sshd

#NO# yum install xauth
#NO# yum install xorg
#NO# yum install openbox
