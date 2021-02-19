#!/bin/sh

# xinitrc runs automatically when you run startx.

# There are some small but important commands that need to be run when we start
# the graphical environment. I keep those commands in ~/.xprofile because that
# file is run automatically if someone uses a display manager (login screen)
# and so they are needed there. To prevent doubling up commands, I source them
# here with the line below.

[ -f ~/.xprofile ] && . ~/.xprofile
xrdb -merge ~/.Xresources


# Here we start dwm.
# The loop is just to enable dwm's "restart" feature (mod+F2).

while :; do
	ssh-agent dwm || break
done


# exec --no-startup-id /usr/lib/polkit-1/polkit-agent-helper-1 &
# exec --no-startup-id /bin/console-kit-daemon &
# exec ck-launch-session dbus-launch --sh-syntax --exit-with-session dwm
#exec dwm

# start lxde
# exec startlxde
# exec start-lumina-desktop
# exec startlxqt
# exec mate-session

# [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
