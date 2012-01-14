#!/bin/sh
gksu cp ~/Projects/BulletVapi/Bullet-C-Api/Bullet-C-Api.h /usr/local/include/bullet/Bullet-C-Api.h


cd ~/Projects/BulletVapi
vala-gen-introspect bullet VapigenPackage
vapigen --library bullet ~/Projects/BulletVapi/VapigenPackage/bullet.gi ~/Projects/BulletVapi/VapigenPackage/bullet-custom.vala
gksu cp bullet.vapi /usr/local/share/vala-0.12/vapi/bullet.vapi
mplayer /usr/local/etc/Knock.wav  > /dev/null 2>&1

