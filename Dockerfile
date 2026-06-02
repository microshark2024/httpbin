FROM python:3.9-slim

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /httpbin

# 直接复制项目所有文件
COPY . /httpbin

# 1. 安装基础依赖 2. 安装项目本身 3. 安装生产专用的 gunicorn
RUN pip install --no-cache-dir gunicorn && \
    pip install --no-cache-dir -e .

# 动态绑定 Cloud Run 注入的 $PORT 环境变量
CMD ["sh", "-c", "gunicorn -b 0.0.0.0:$PORT httpbin:app"]
