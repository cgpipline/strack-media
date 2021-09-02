# 使用centos开启
FROM centos:centos7

MAINTAINER weijer

# 添加 pngquant rpm源
RUN mkdir -p /tmp
COPY epel/epel-release-7-13.noarch.rpm /tmp/epel-release-7-13.noarch.rpm
RUN rpm -Uvh /tmp/epel-release-7-13.noarch.rpm

# tools
RUN yum -y update

RUN yum -y install \
        vim \
        libxml2 \
        libxml2-devel \
        libjpeg-turbo \
        libjpeg-turbo-devel \
        libpng \
        libpng-devel \
        pngquant \
        curl \
        curl-devel \
        libxslt \
        libxslt-devel \
        freetype-devel \
        libXrender-devel.x86_64 \
        libSM.x86_64 \
        libXext.x86_64 \
        python-setuptools \
    && cp -frp /usr/lib64/libldap* /usr/lib/  \
    && rm -rf /var/cache/{yum,ldconfig}/* \
    && rm -rf /etc/ld.so.cache \
    && yum clean all

RUN mkdir -p /app

# 配置工作目录
WORKDIR /app/

ENV SRC_DIR /app

# log 容器时区处理
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 拷贝配置文件
COPY ./config/application.yml /app/config/application.yml

# 拷贝natron文件
ADD install/natron.tar.gz ${SRC_DIR}/

# 拷贝static文件
ADD install/static.tar.gz ${SRC_DIR}/

# 拷贝编译程序
COPY strack_media /usr/local/bin/

RUN chmod +x /usr/local/bin/strack_media

# 运行!
CMD ["/usr/local/bin/strack_media"]

# 打开8080端口
EXPOSE 8080
