# Build with
# docker build -t armclipse:`date +%Y-%m-%d` .
# Installs Eclipse, some plugins, and latest Java
# run with something like
# (Assumes you have the proper directories in your home folder)
#!/bin/sh
#touch /tmp/.docker.xauth;
#XSOCK=/tmp/.X11-unix;
#XAUTH=/tmp/.docker.xauth;
#DOCHOME=/home/armclipse;
#xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -;
#docker run -d --rm -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v $HOME/.m2:/home/armclipse/.m2 -e DISPLAY=unix$DISPLAY -e XAUTHORITY=$XAUTH -v $HOME/eclipse/workspaces:$DOCHOME/workspaces -v $HOME/Repos:$DOCHOME/Repos armclipse:4.7.3a /usr/bin/eclipse -data $DOCHOME/workspaces/default
#
#Then in xfce launcher,
#bash -i -c /home/alarm/eclipse/run.sh

FROM fedora:31
RUN dnf update -y; \
    dnf module enable -y eclipse:latest; \
    dnf install -y eclipse eclipse-pydev eclipse-pydev-mylyn eclipse-eclemma eclipse-findbugs eclipse-findbugs-contrib eclipse-egit-github eclipse-egit-mylyn eclipse-mylyn-context-java eclipse-mylyn-context-pde eclipse-mylyn-tasks-web eclipse-mylyn-versions eclipse-mylyn-versions-git eclipse-mylyn-builds eclipse-mylyn-builds-hudson eclipse-m2e-egit eclipse-m2e-maven-dependency-plugin eclipse-m2e-mavenarchiver eclipse-m2e-buildhelper eclipse-m2e-core-javadoc eclipse-m2e-workspace-javadoc eclipse-dltk-sh java-latest-openjdk java-latest-openjdk-javadoc java-latest-openjdk-src java-latest-openjdk-jmods dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts chromium chromedriver binutils; \
    sed -i -e 's/-Xmx1024m/-Xmx2048m/g' /usr/lib/eclipse/eclipse.ini; \
    useradd -ms /bin/bash armclipse;
USER armclipse
RUN /usr/bin/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository https://eclipse-uc.sonarlint.org,https://dl.bintray.com/de-jcup/basheditor -installIUs org.sonarlint.eclipse.feature.feature.group,de.jcup.basheditor.feature.group; \
    /usr/bin/eclipse -initialize;
