#!/bin/sh

gksu cp ~/Projects/BulletVapi/Bullet-C-Api/Bullet-C-Api.h ~/Projects/bullet-2.77/src/Bullet-C-Api.h
gksu cp ~/Projects/BulletVapi/Bullet-C-Api/Bullet-C-API.cpp ~/Projects/bullet-2.77/src/BulletDynamics/Dynamics/Bullet-C-API.cpp
gksu cp ~/Projects/BulletVapi/BulletDinoDemo/BulletDino.c ~/Projects/bullet-2.77/Demos/BulletDinoDemo/BulletDino.c
cd ~/Projects/bullet-2.77
# cmake . -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON
 make -j4
 gksu make install

make_vapi

