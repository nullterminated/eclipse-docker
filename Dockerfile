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
#docker run -d --rm -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v $HOME/.m2:/home/armclipse/.m2 -e DISPLAY=unix$DISPLAY -e XAUTHORITY=$XAUTH -v $HOME/eclipse/workspaces:$DOCHOME/workspaces -v $HOME/Repos:$DOCHOME/Repos armclipse:2020-09-01 /usr/bin/eclipse -data $DOCHOME/workspaces/default
#
#Then in xfce launcher,
#bash -i -c /home/alarm/eclipse/run.sh

FROM fedora:32
RUN dnf update -y; \
    dnf module enable -y eclipse:latest;
RUN dnf install -y eclipse-jdt eclipse-linuxtools eclipse-linuxtools-docker eclipse-dtp eclipse-webtools-sourceediting eclipse-egit-github eclipse-findbugs-contrib eclipse-mylyn eclipse-mylyn-context-* eclipse-mylyn-tasks-* eclipse-mylyn-builds jacoco java-latest-openjdk java-latest-openjdk-javadoc java-latest-openjdk-src java-latest-openjdk-jmods dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts chromium chromedriver binutils nodejs;
RUN sed -i -e 's/-Xmx1024m/-Xmx2048m/g' /usr/lib/eclipse/eclipse.ini; \
    useradd -ms /bin/bash armclipse;
RUN alternatives --set java java-latest-openjdk.aarch64;
USER armclipse
RUN /usr/bin/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/2020-03,https://dl.bintray.com/de-jcup/basheditor -installIUs org.eclipse.m2e.feature.feature.group,org.eclipse.eclemma.feature.feature.group,org.eclipse.wildwebdeveloper.feature.feature.group,de.jcup.basheditor.feature.group; \
    /usr/bin/eclipse -initialize;
RUN curl -o /home/armclipse/findsecbugs-plugin-1.10.1.jar -L https://search.maven.org/remotecontent?filepath=com/h3xstream/findsecbugs/findsecbugs-plugin/1.10.1/findsecbugs-plugin-1.10.1.jar
