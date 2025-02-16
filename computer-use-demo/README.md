# Computer Control with Cursor

This project provides a Docker container with a virtual desktop environment accessible through a web browser, with proper cursor support.

## Prerequisites

- Docker installed on your system
- A web browser
- Git (for cloning the repository)

## Installation and Running

1. Clone the repository:
```bash
git clone https://github.com/bryjudy/computer_control_with_cursor
cd computer_control_with_cursor
```

2. Build the Docker image:
```bash
docker build -t computer-control-cursor .
```

3. Anthropic key then run the container:
```bash
 export ANTHROPIC_API_KEY=%your_api_key%
docker run \
  --name computer-control-cursor \
  --privileged \
  -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
  -v "$HOME/.anthropic:/home/computeruse/.anthropic" \
  -p 5900:5900 \
  -p 8501:8501 \
  -p 6080:6080 \
  -p 8080:8080 \
  -p 2375:2375 \
  --shm-size=1g \
  -it \
  computer-control-cursor
```

4. Access the virtual desktop:
   - Open your web browser
   - Navigate to `http://localhost:8080/vnc.html`
   - You should see the virtual desktop environment

## Important Notes

- The container exposes port 8080 for web access
- The virtual desktop resolution is set to 1024x768
- The environment uses IceWM as the window manager
- Cursor support is enabled using the DMZ-White theme

## Stopping the Container

To stop the container:
```bash
docker stop computer-control
```

To remove the container:
```bash
docker rm computer-control
```

## Troubleshooting

If you encounter issues:

1. Check container logs:
```bash
docker logs computer-control
```

2. Verify the container is running:
```bash
docker ps
```

3. If the web interface isn't responding, ensure port 8080 isn't being used by another application

4. For cursor issues, try refreshing the browser page