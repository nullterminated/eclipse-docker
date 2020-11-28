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

FROM fedora:33
RUN dnf update -y;
RUN dnf install -y eclipse-jdt eclipse-egit eclipse-cdt-terminal eclipse-mpc eclipse-webtools-sourceediting eclipse-findbugs-contrib jacoco java-latest-openjdk java-latest-openjdk-javadoc java-latest-openjdk-src java-latest-openjdk-jmods dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts chromium chromedriver binutils nodejs yarnpkg;
RUN sed -i -e 's/-Xmx1024m/-Xmx2048m/g' /usr/lib/eclipse/eclipse.ini; \
    useradd -ms /bin/bash armclipse; \
    alternatives --set java java-latest-openjdk.aarch64;
USER armclipse
RUN curl -o /home/armclipse/findsecbugs-plugin-1.11.0.jar -L https://search.maven.org/remotecontent?filepath=com/h3xstream/findsecbugs/findsecbugs-plugin/1.11.0/findsecbugs-plugin-1.11.0.jar;
RUN /usr/bin/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/2020-06,https://dl.bintray.com/de-jcup/basheditor -installIUs de.jcup.basheditor.feature.group,org.eclipse.mylyn.ide_feature.feature.group,org.eclipse.mylyn.java_feature.feature.group,org.eclipse.mylyn.context_feature.feature.group,org.eclipse.mylyn.bugzilla_feature.feature.group,org.eclipse.mylyn.wikitext_feature.feature.group,org.eclipse.mylyn.git.feature.group,org.eclipse.mylyn_feature.feature.group,org.eclipse.m2e.feature.feature.group,org.eclipse.eclemma.feature.feature.group,org.eclipse.wildwebdeveloper.feature.feature.group; \
    /usr/bin/eclipse -initialize;


