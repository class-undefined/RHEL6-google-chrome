docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v /dev/snd:/dev/snd \
            -v /dev/shm:/dev/shm \
            --privileged \
            -e uid=$(id -u) \
            -e gid=$(id -g) \
            -e DISPLAY=unix$DISPLAY \
            --net=host \
            --rm \
            --name google-chrome \
            classundefined/google-chrome:latest

