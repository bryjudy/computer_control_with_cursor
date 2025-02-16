FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_PRIORITY=high

# 1. Install system-level packages (including xfce + supervisor)
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    xvfb \
    xterm \
    xdotool \
    scrot \
    imagemagick \
    sudo \
    x11vnc \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    curl \
    git \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    net-tools \
    netcat \
    software-properties-common \
    supervisor \
    xfce4 \
    xfce4-goodies && \
    sudo add-apt-repository ppa:mozillateam/ppa && \
    apt-get install -y --no-install-recommends \
    libreoffice \
    firefox-esr \
    x11-apps \
    xpdf \
    gedit \
    xpaint \
    tint2 \
    galculator \
    pcmanfm \
    unzip && \
    apt-get clean

# 2. Install noVNC in /opt
RUN git clone --branch v1.5.0 https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone --branch v0.12.0 https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html && \
    ln -s /opt/noVNC /usr/local/novnc

# 3. Install Docker (daemon + CLI) for Docker-in-Docker
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# -- Docker-in-Docker configuration --
# Disables TLS (not recommended for production)
ENV DOCKER_TLS_CERTDIR=""
# Docker will listen on the Unix socket by default
ENV DOCKER_HOST="unix:///var/run/docker.sock"
# Expose port 2375 if you want to connect externally (insecure)
EXPOSE 2375

# 4. Create a non-root user
ENV USERNAME=computeruse
ENV HOME=/home/$USERNAME
RUN useradd -m -s /bin/bash -d $HOME $USERNAME
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 5. Switch to non-root for Python/pyenv
USER $USERNAME
WORKDIR $HOME

# 6. Install pyenv and Python 3.11.6
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    cd ~/.pyenv && src/configure && make -C src && cd .. && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"
ENV PYENV_VERSION_MAJOR=3
ENV PYENV_VERSION_MINOR=11
ENV PYENV_VERSION_PATCH=6
ENV PYENV_VERSION=$PYENV_VERSION_MAJOR.$PYENV_VERSION_MINOR.$PYENV_VERSION_PATCH

RUN eval "$(pyenv init -)" && \
    pyenv install $PYENV_VERSION && \
    pyenv global $PYENV_VERSION && \
    pyenv rehash

# 7. Upgrade pip/setuptools/wheel
ENV PATH="$HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH"
RUN python -m pip install --upgrade pip==23.1.2 setuptools==58.0.4 wheel==0.40.0 && \
    python -m pip config set global.disable-pip-version-check true

# 8. Copy entire project to /home/computeruse/app
COPY --chown=$USERNAME:$USERNAME . /home/computeruse/app/
WORKDIR /home/computeruse/app

# 9. Install dependencies & package
RUN python -m pip install -r computer_use_demo/requirements.txt
RUN python -m pip install -e .

# 10. Build args / environment
ARG DISPLAY_NUM=1
ARG HEIGHT=768
ARG WIDTH=1024
ENV DISPLAY_NUM=$DISPLAY_NUM
ENV HEIGHT=$HEIGHT
ENV WIDTH=$WIDTH

# 11. Cursor script (if any)
RUN chmod +x cursor_installer.sh && \
    ./cursor_installer.sh

# 12. Supervisor config, etc. (root user to place config in /etc)
USER root
RUN cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    chown -R computeruse:computeruse /home/computeruse

# Remain as root for Supervisor + Docker
WORKDIR /home/computeruse/app

# 13. Environment
ENV HOME=/home/computeruse \
    SHELL=/bin/bash \
    DISPLAY=:0.0 \
    RESOLUTION=1024x768

# 14. Expose ports (noVNC typically on 8080; Docker on 2375 is already exposed above)
EXPOSE 8080

# 15. Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]