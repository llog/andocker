FROM ubuntu:latest

MAINTAINER huaixiaoz "hello@ifnot.cc"

## Install java7
#RUN apt-get update && \
#  apt-get install -y software-properties-common && \
#  add-apt-repository -y ppa:webupd8team/java && \
#  (echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
#  apt-get update && \
#  apt-get install -y oracle-java7-installer && \
#  apt-get clean && \
#  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
#ENV JAVA7_HOME /usr/lib/jvm/java-7-oracle

## Install oracle java8
## Install java8
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  apt-get clean && \
  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV JAVA8_HOME=/usr/lib/jvm/java-8-oracle \
  JAVA_HOME=/usr/lib/jvm/java-8-oracle

## Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages unzip expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
## Custom Tools
RUN apt-get update && apt-get install -y psmisc htop vim make gradle bash-completion cloc net-tools iputils-ping netcat cmake ninja-build openssh-server && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install Android SDK
ARG SDK_TOOL_FILENAME=sdk-tools-linux-3859397.zip
ENV SDK_TOOL_URL=https://dl.google.com/android/repository/$SDK_TOOL_FILENAME \
  ANDROID_APIS="android-10,android-15,android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25" \
  GRADLE_HOME="/usr/share/gradle" \
  ANDROID_HOME="/opt/android" \
  ANDROID_BUILD_TOOLS_VERSION=26.0.0
#  ANDROID_TOOLS=tools \
ENV  PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANDROID_HOME/ndk-bundle:$GRADLE_HOME/bin

RUN cd /opt && wget --output-document=$SDK_TOOL_FILENAME --quiet $SDK_TOOL_URL && \
  unzip $SDK_TOOL_FILENAME -d $ANDROID_HOME && rm -f $SDK_TOOL_FILENAME   && chown -R root.root $ANDROID_HOME
#RUN cd /opt && wget --output-document=android-ndk-r11c-linux-x86_64.zip --quiet http://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip && unzip android-ndk-r11c-linux-x86_64.zip && rm -f android-ndk-r11c-linux-x86_64.zip && chown -R root.root android-ndk-r11c

### update tools
RUN echo "yes" | sdkmanager --update
### install package
ENV ANDROID_PACKAGES "build-tools;26.0.0 build-tools;25.0.3 platforms;android-25 platforms;android-26 platform-tools emulator patcher;v4 extras;android;m2repository extras;google;google_play_services extras;google;instantapps extras;google;m2repository ndk-bundle system-images;android-26;google_apis_playstore;x86"
RUN echo "yes" | sdkmanager $ANDROID_PACKAGES

############# deleted ##############
# Setup environment
# ENV ANDROID_NDK_HOME /opt/android-ndk-r11c
# ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_NDK_HOME}

# Install sdk elements
# RUN echo "yes" | android update sdk --all --force --no-ui --filter "tools"
# RUN echo "yes" | android update sdk --all --force --no-ui --filter "platform-tools,build-tools-23.0.3,android-23,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,sys-img-armeabi-v7a-android-23"
############# deleted ##############

RUN which adb
RUN which android
RUN which ndk-build

# Create emulator
RUN echo "no" | android create avd \
        --force \
        --device "Nexus 5" \
        --name test \
        --target android-23 \
        --abi armeabi-v7a \
        --skin WVGA800 \
        --sdcard 100M

# Cleaning
RUN  rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* && apt-get clean

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
