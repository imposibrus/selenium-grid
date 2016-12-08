FROM ubuntu:16.04
MAINTAINER imposibrus

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install fluxbox tightvncserver xdm -y
RUN apt-get install -y wget openjdk-8-jre-headless
RUN wget -qO- http://dl.google.com/android/android-sdk_r23-linux.tgz | tar xz -C /usr/local/ && mv /usr/local/android-sdk-linux /usr/local/android-sdk && chown -R root:root /usr/local/android-sdk/

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Install latest android tools and system images
RUN ( sleep 4 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk --no-ui --force -a --filter \
    platform-tool,android-22,build-tools-22.0.1,sys-img-armeabi-v7a-android-22 && \
echo "y" | android update adb

# Create fake keymap file
RUN mkdir /usr/local/android-sdk/tools/keymaps && \
touch /usr/local/android-sdk/tools/keymaps/en-us


ENV USER root
ENV DISPLAY :1
ENV TERM xterm

COPY password.txt .
RUN cat password.txt password.txt | vncpasswd && rm password.txt

EXPOSE 5901
EXPOSE 5554
EXPOSE 5555
EXPOSE 22

COPY vnc.sh /opt/

CMD ["/opt/vnc.sh"]

