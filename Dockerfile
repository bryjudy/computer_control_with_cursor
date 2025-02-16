FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN git clone --branch v1.5.0 https://github.com/novnc/noVNC /usr/local/novnc

# Create user
RUN useradd -m -s /bin/bash -d /home/computeruse computeruse
RUN echo "computeruse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Docker
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install desktop environment and applications
RUN apt-get update && \
    apt-get install -y libgtk-3-0 libasound2 icewm firefox-esr git supervisor x11vnc xvfb python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy cursor installer script and execute it
COPY cursor_installer.sh /tmp/
RUN chmod +x /tmp/cursor_installer.sh && \
    /tmp/cursor_installer.sh

# Set up VNC and window manager configuration
COPY icewm.preferences /home/computeruse/.icewm/preferences
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set working directory
WORKDIR /home/computeruse

# Set up environment
ENV HOME=/home/computeruse \
    SHELL=/bin/bash \
    DISPLAY=:0.0 \
    RESOLUTION=1024x768

# Update ownership
RUN chown -R computeruse:computeruse /home/computeruse

# Expose ports
EXPOSE 8080

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]