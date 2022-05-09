FROM debian:11-slim

# Update and add additional repos
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y curl && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Change active shell in order to 'source' files later
SHELL ["/bin/bash", "-c"]

# Copy third party binaries (android tools)
COPY resources /tmp

# Move Android CLI files and set the environment variables
RUN apt-get install zip unzip && \ 
    mkdir -p /opt/android/sdk/cmdline-tools && \
    unzip /tmp/commandlinetools-linux-8092744_latest.zip -d /opt/android/sdk/cmdline-tools/tools && \
    mv /opt/android/sdk/cmdline-tools/tools/cmdline-tools/* /opt/android/sdk/cmdline-tools/tools && \
    rm -r /opt/android/sdk/cmdline-tools/tools/cmdline-tools && rm -r /tmp/* && \
    echo "ANDROID_HOME=/opt/android/sdk" >> /root/.bashrc && \
    echo "PATH=/opt/android/sdk/cmdline-tools/tools/bin:/opt/android/sdk/platform-tools:/opt/android/sdk/build-tools:$PATH" >> /root/.bashrc

# Install java, gradle, nodejs and npm
RUN curl -s "https://get.sdkman.io" | bash && \
    source "/root/.sdkman/bin/sdkman-init.sh" && \
    sdk list java && \
    sdk install java 8.332.08.1-amzn && \
    sdk install gradle 6.9.2 && \
    source /root/.bashrc && \
    nvm install 14 && \
    apt-get install -y npm && \
    source /root/.bashrc && \
    sdkmanager --update && \
    yes | sdkmanager --licenses && \
    sdkmanager "build-tools;30.0.3" "platforms;android-30" "tools" && \
    yes | npm i -g cordova && \
    yes | npm i -g cordova-res && \
    yes | npm install -g @ionic/cli
