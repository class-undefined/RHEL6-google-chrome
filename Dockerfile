# 使用Ubuntu作为基础镜像
FROM centos:7
# RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
#     -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
#     -i.bak \
#     /etc/yum.repos.d/CentOS-*.repo \
#     && yum makecache


RUN yum install -y epel-release \
    && yum update -y \
    && yum install -y \
    wget \
    gnupg2 \
    xorg-x11-server-Xvfb \
    xorg-x11-xauth \
    xorg-x11-apps \
    google-chrome-stable \
    dejavu-sans-fonts \
    && yum clean all
COPY ./res/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
# 添加Google Chrome的官方仓库，并安装Chrome

RUN yum install -y google-chrome-stable --nogpgcheck

RUN yum -y install gcc-c++ ruby libX11-devel libXrender-devel libXext-devel python-devel \
    && wget --no-check-certificate https://www.klayout.org/downloads/CentOS_7/klayout-0.28.9-0.x86_64.rpm -P /tmp \
    && wget --no-check-certificate https://www.klayout.org/downloads/gpg-public.key -P /tmp \
    && gpg --import /tmp/gpg-public.key \
    && yum localinstall -y /tmp/klayout-0.28.9-0.x86_64.rpm \
    && rm -rf /tmp/klayout* \
    && rm -rf /tmp/gpg-public.key

# 添加非root用户以启动Chrome，因为Chrome不推荐以root权限运行
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
