FROM ghcr.io/cirruslabs/android-sdk:33

RUN useradd -m vscode
RUN apt-get update \
    && apt-get install -y sudo cmake ninja-build clang build-essential pkg-config libgtk-3-dev liblzma-dev lcov \
    && echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

USER vscode
WORKDIR /home/vscode

ARG flutter_version=3.10.5

ENV FLUTTER_HOME=/home/vscode/sdks/flutter \
    FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN yes | flutter doctor --android-licenses \
    && flutter doctor \
    && chown -R vscode:vscode ${FLUTTER_HOME}

RUN flutter config --enable-linux-desktop
