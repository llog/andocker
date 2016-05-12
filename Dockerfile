FROM ubuntu:latest

MAINTAINER huaixiaoz "hello@itmp.top"

## Install oracle java8

RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

## Install Deps

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl

## Install Android SDK

RUN cd /opt && wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar xzf android-sdk.tgz && rm -f android-sdk.tgz && chown -R root.root android-sdk-linux

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install sdk elements
RUN echo "yes" | android update sdk --all --force --no-ui --filter "tools"
RUN echo "yes" | android update sdk --all --force --no-ui --filter "platform-tools,build-tools-23.0.3,android-23,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,sys-img-armeabi-v7a-android-23"

RUN which adb
RUN which android

# Create emulator
RUN echo "no" | android create avd \
        --force \
        --device "Nexus 5" \
        --name test \
        --target android-23 \
        --abi armeabi-v7a \
        --skin WVGA800 \
        --sdcard 512M

# Cleaning
RUN apt-get clean

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
