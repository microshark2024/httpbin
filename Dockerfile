# 1. 放弃沉重的 Ubuntu 18.04，换用轻量且现代的 Python 官方镜像（自带 pip）
FROM python:3.9-slim

# 2. 设置系统编码
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# 3. 安装必要的打包工具（如果项目需要编译某些 C 依赖，可以留着，不需要就保持 slim 纯净）
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# 4. 安装 pipenv 并准备工作目录
RUN pip install --no-cache-dir pipenv
WORKDIR /httpbin

# 5. 复制依赖文件并利用 pipenv 生成 requirements 导入
COPY Pipfile Pipfile.lock /httpbin/
RUN pipenv r > requirements.txt && pip install --no-cache-dir -r requirements.txt

# 6. 将本地代码复制进去并安装项目本身
COPY . /httpbin
RUN pip install --no-cache-dir /httpbin

# 7. 额外安装一个纯粹的 gunicorn（确保最新且不依赖容易暗碎的 gevent）
RUN pip install --no-cache-dir gunicorn

# 8. 核心：去掉 -k gevent，并将端口 80 替换为环境变量 $PORT
CMD ["sh", "-c", "gunicorn -b 0.0.0.0:$PORT httpbin:app"]
