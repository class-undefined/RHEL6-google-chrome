# 使用Ubuntu作为基础镜像
FROM ubuntu:22.04
COPY ./res/sources.list /etc/apt/sources.list
# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# 安装必要的软件包，包括X11客户端库
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    software-properties-common \
    xvfb \
    x11-xserver-utils \
    libx11-xcb1 \
    fonts-wqy-zenhei \  
    --no-install-recommends

# 添加Google Chrome的官方仓库，并安装Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable --no-install-recommends

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# RUN wget https://www.klayout.org/downloads/Ubuntu-20/klayout_0.29.1-1_amd64.deb
# RUN apt-get install -y git qt5-default \ 
#     && dpkg -i klayout_0.29.1-1_amd64.deb \
#     && apt-get install -f \
#     && rm klayout_0.29.1-1_amd64.deb


RUN groupadd -r chrome && \
    useradd -r -g chrome -G audio,video chrome && \
    mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

USER chrome
WORKDIR /home/chrome

# 使用“xhost +”命令来允许所有的X11客户端访问宿主机的X11服务
# 这个命令应在宿主机上运行
# 你可以在启动容器之前在宿主机上运行这个命令：
# xhost +local:root

# 设置容器内部环境变量以使用宿主机的显示配置
ENV DISPLAY host.docker.internal:0

# 运行Google Chrome
CMD [ "google-chrome", "--no-sandbox", "--disable-gpu" ]
