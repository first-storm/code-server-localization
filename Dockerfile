FROM codercom/code-server:4.95.3-bookworm

# 切换到 root 用户以安装软件包
USER root

# 系统更新和安装必要工具
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        bash \
        fonts-firacode \
        g++ \
        gdb \
        cmake \
        locales \
        ca-certificates \
        curl \
        gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置中文语言环境
RUN sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/" /etc/locale.gen && \
    locale-gen

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8

# 设置扩展市场服务 URL
ENV EXTENSIONS_GALLERY='{"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "itemUrl": "https://marketplace.visualstudio.com/items"}'

# Copy the settings.json file and set permissions
COPY settings.json /home/defaultconfig/.local/share/code-server/User/
RUN chmod 777 /home/defaultconfig/.local/share/code-server/User/settings.json

# 安装 VS Code 扩展
RUN HOME=/home/defaultconfig code-server \
    --user-data-dir=/home/defaultconfig/.local/share/code-server \
    --install-extension ms-ceintl.vscode-language-pack-zh-hans \
    --install-extension formulahendry.code-runner \
    --install-extension ms-vscode.cmake-tools \
    --install-extension ms-vscode.cpptools \
    --install-extension twxs.cmake \
    --install-extension ms-vscode.cpptools-themes

# 设置最终配置
USER coder
ENV USER=coder
WORKDIR /home/coder

# 设置启动命令和端口
EXPOSE 8080
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]
