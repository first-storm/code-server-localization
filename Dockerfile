FROM codercom/code-server

# Switch to root user to install packages
USER root

# Install build-essential, gcc, g++, gdb, cmake
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    gdb \
    cmake && \
    rm -rf /var/lib/apt/lists/*

# Set the locale to zh_CN.UTF-8 (Mainland China)
RUN sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/" /etc/locale.gen && \
    locale-gen

ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# Set the extensions gallery service URL
ENV EXTENSIONS_GALLERY='{"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery"}'

# Install the Chinese (Simplified) Language Pack for Visual Studio Code
RUN code-server --install-extension ms-ceintl.vscode-language-pack-zh-hans && \
    code-server --install-extension formulahendry.code-runner && \
    code-server --install-extension ms-vscode.cmake-tools && \
    code-server --install-extension twxs.cmake && \
    code-server --install-extension ms-vscode.cpptools-themes

# Ensure the extensions directory exists
RUN mkdir -p /home/coder/.local/share/code-server/extensions

# Switch back to the coder user
USER coder

# Set the working directory
WORKDIR /home/coder

# Expose the default port
EXPOSE 8080

# Start code-server
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["--bind-addr", "0.0.0.0:8080", "."]

