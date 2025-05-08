#
# SPDX-FileCopyrightText: 2023-2025 Aayush Gupta <aayushgupta219@gmail.com>
# SPDX-License-Identifier: Apache-2.0
#

FROM ubuntu:24.04

# Global Android command-line tools from https://developer.android.com/studio
ARG ANDROID_CMDLINE_TOOLS_VERSION=13114758
ENV ANDROID_SDK_ROOT "/sdk"
ENV ANDROID_HOME "/sdk"
ARG ANDROID_CMDLINE_TOOLS_BIN="${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin"

# Add SDK tools to the PATH
ENV PATH "$PATH:${ANDROID_CMDLINE_TOOLS_BIN}/:${ANDROID_HOME}/emulator/:${ANDROID_HOME}/platform-tools/:${ANDROID_HOME}/build-tools/35.0.0/"

# Setup distribution and install required distribution packages
ARG JDK_VERSION=21
ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --print-architecture && \
    dpkg --print-foreign-architectures

RUN dpkg --add-architecture i386 && \
    dpkg --print-foreign-architectures

RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
      curl \
      git-core \
      openjdk-${JDK_VERSION}-jdk \
      libc6-i386 \
      libstdc++6:i386 \
      zlib1g:i386 \
      unzip \
      make \
      locales \
      autoconf \
      automake \
      libtool \
      pkg-config \
      wget \
      gcc \
      libsonic-dev \
      libpcaudio-dev \
      zip

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Download and install SDK command-line tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/tools && \
    rm *tools*linux*.zip

RUN yes | ${ANDROID_CMDLINE_TOOLS_BIN}/sdkmanager --licenses

RUN mkdir -p /root/.android \
 && touch /root/.android/repositories.cfg \
 && sdkmanager --verbose --update

ADD packages.txt /sdk
RUN sdkmanager --verbose --package_file=/sdk/packages.txt
