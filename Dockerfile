FROM codercom/code-server:4.93.1-bookworm

# 切换到 root 用户以安装软件包
USER root

# 安装必要的编译工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    gdb \
    cmake && \
    rm -rf /var/lib/apt/lists/*

# 设置中文语言环境
RUN sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/" /etc/locale.gen && \
    locale-gen

ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 设置扩展市场服务 URL
ENV EXTENSIONS_GALLERY='{"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "itemUrl": "https://marketplace.visualstudio.com/items"}'




# 安装 VS Code 扩展
RUN HOME=/home/coder code-server \
    --user-data-dir=/home/coder/.local/share/code-server \
    --install-extension ms-ceintl.vscode-language-pack-zh-hans \
    --install-extension formulahendry.code-runner \
    --install-extension ms-vscode.cmake-tools \
    --install-extension ms-vscode.cpptools \
    --install-extension twxs.cmake \
    --install-extension ms-vscode.cpptools-themes


# 切换回 coder 用户
USER coder


# 设置工作目录
WORKDIR /home/coder

# 暴露默认端口
EXPOSE 8080
