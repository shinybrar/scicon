#!/bin/bash
#NB: needs to be edited for casa version in first coding line below
# AppImage fix applies now too casaviewer, casaplotms
# and new: casalogger, casaplotserver, casatablebrowser, casafeather

casavers=casa-6.1.0-118
#casavers=casa-6.1.1-15-pipeline-2020.1.0.40

pyvers=python3.6

pushd /opt
#below command was original way of structuring this, but not working anymore
#manually inputting casavers above to get around this
#casaviewer=$(python3 -m casaviewer --app-path 2> /dev/null | grep casaviewer)
#echo ${casaviewer}
casaviewer=/opt/${casavers}/lib/py/lib/${pyvers}/site-packages/casaviewer/__bin__/casaviewer-x86_64.AppImage
${casaviewer} --appimage-extract 2> /dev/null

mv /opt/casa/bin/casaviewer /opt/casa/bin/casaviewer.old
ln -s /opt/squashfs-root/AppRun /opt/casa/bin/casaviewer

#additional steps courtesy of CASA helpdesk
#NB: casa6.5 and higher use python3.8, only option
mv /opt/casa/lib/py/lib/${pyvers}/site-packages/casaviewer/__bin__/casaviewer-x86_64.AppImage /opt/casa/lib/py/lib/${pyvers}/site-packages/casaviewer/__bin__/casaviewer-x86_64.AppImage.orig
ln -s /opt/squashfs-root/usr/bin/casaviewer /opt/casa/lib/py/lib/${pyvers}/site-packages/casaviewer/__bin__/casaviewer-x86_64.AppImage

#Apply similar process for other packages
#1) extract AppImage
/opt/${casavers}/lib/py/lib/${pyvers}/site-packages/casaplotms/__bin__/casaplotms-x86_64.AppImage --appimage-extract 2> /dev/null
/opt/${casavers}/lib/py/lib/${pyvers}/site-packages/casalogger/__bin__/casalogger-x86_64.AppImage --appimage-extract 2> /dev/null
/opt/${casavers}/lib/py/lib/${pyvers}/site-packages/casafeather/__bin__/casafeather-x86_64.AppImage --appimage-extract 2> /dev/null
/opt/${casavers}/lib/py/lib/${pyvers}/site-packages/casaplotserver/__bin__/casaplotserver-x86_64.AppImage --appimage-extract 2> /dev/null
/opt/${casavers}/lib/py/lib/${pyvers}/site-packages/casatablebrowser/__bin__/casatablebrowser-x86_64.AppImage --appimage-extract 2> /dev/null

#2a) move old AppImage
mv /opt/casa/lib/py/lib/${pyvers}/site-packages/casaplotms/__bin__/casaplotms-x86_64.AppImage /opt/casa/lib/py/lib/${pyvers}/site-packages/casaplotms/__bin__/casaplotms-x86_64.AppImage.orig
mv /opt/casa/lib/py/lib/${pyvers}/site-packages/casalogger/__bin__/casalogger-x86_64.AppImage /opt/casa/lib/py/lib/${pyvers}/site-packages/casalogger/__bin__/casalogger-x86_64.AppImage.orig
mv /opt/casa/lib/py/lib/${pyvers}/site-packages/casafeather/__bin__/casafeather-x86_64.AppImage /opt/casa/lib/py/lib/${pyvers}/site-packages/casafeather/__bin__/casafeather-x86_64.AppImage.orig
mv /opt/casa/lib/py/lib/${pyvers}/site-packages/casaplotserver/__bin__/casaplotserver-x86_64.AppImage /opt/casa/lib/py/lib/${pyvers}/site-packages/casaplotserver/__bin__/casaplotserver-x86_64.AppImage.orig
mv /opt/casa/lib/py/lib/${pyvers}/site-packages/casatablebrowser/__bin__/casatablebrowser-x86_64.AppImage /opt/casa/lib/py/lib/${pyvers}/site-packages/casatablebrowser/__bin__/casatablebrowser-x86_64.AppImage.orig

#2b) link to new one
ln -s /opt/squashfs-root/usr/bin/casaplotms /opt/casa/lib/py/lib/${pyvers}/site-packages/casaplotms/__bin__/casaplotms-x86_64.AppImage
ln -s /opt/squashfs-root/usr/bin/casalogger /opt/casa/lib/py/lib/${pyvers}/site-packages/casalogger/__bin__/casalogger-x86_64.AppImage
ln -s /opt/squashfs-root/usr/bin/casafeather /opt/casa/lib/py/lib/${pyvers}/site-packages/casafeather/__bin__/casafeather-x86_64.AppImage
ln -s /opt/squashfs-root/usr/bin/casaplotserver /opt/casa/lib/py/lib/${pyvers}/site-packages/casaplotserver/__bin__/casaplotserver-x86_64.AppImage
ln -s /opt/squashfs-root/usr/bin/casatablebrowser /opt/casa/lib/py/lib/${pyvers}/site-packages/casatablebrowser/__bin__/casatablebrowser-x86_64.AppImage


popd
