FROM centos:7
MAINTAINER Koray YILMAZ <kyilmaz80@gmail.com>

ENV LEPTONICA_VER 1.74.4

# build essentials
RUN yum -y --setopt=tsflags=nodocs update && \
	yum -y --setopt=tsflags=nodocs install autoconf && \
	yum -y --setopt=tsflags=nodocs install libpng12-devel && \
	yum -y --setopt=tsflags=nodocs install libjpeg-turbo-devel && \
	yum -y --setopt=tsflags=nodocs install gcc && \
	yum -y --setopt=tsflags=nodocs install gcc-c++ && \
	yum -y --setopt=tsflags=nodocs install libtiff-devel && \
	yum -y --setopt=tsflags=nodocs install opencv-devel && \
	yum -y --setopt=tsflags=nodocs install epel-release && \
	yum -y --setopt=tsflags=nodocs install leptonica-devel && \
	yum -y --setopt=tsflags=nodocs install log4cplus-devel && \
	yum -y --setopt=tsflags=nodocs install libcurl-devel && \
	yum -y --setopt=tsflags=nodocs install python-devel && \
	yum -y --setopt=tsflags=nodocs install tk && \
	yum -y --setopt=tsflags=nodocs install tk-devel && \
	yum -y --setopt=tsflags=nodocs install python-imaging && \
	yum -y --setopt=tsflags=nodocs install ImageMagick && \
	yum -y --setopt=tsflags=nodocs install python-virtualenv && \
	yum -y --setopt=tsflags=nodocs install wget && \
    yum clean all

RUN yum -y --setopt=tsflags=nodocs install libtool && \
	yum -y --setopt=tsflags=nodocs install automake && \
	yum -y --setopt=tsflags=nodocs install cmake && \
	yum clean all

RUN yum -y --setopt=tsflags=nodocs install make && \
	yum clean all

# leptonica
WORKDIR /usr/local/src/
RUN wget http://www.leptonica.org/source/leptonica-${LEPTONICA_VER}.tar.gz && \
	tar xvzf leptonica-${LEPTONICA_VER}.tar.gz && \
	cd leptonica-${LEPTONICA_VER} && \
 	./autobuild && \
	./configure && \
	make && \
	make install && \
	ldconfig && \
	rm -rf /usr/local/src/leptonica-${LEPTONICA_VER}

# tesseract
RUN yum -y --setopt=tsflags=nodocs update && \
	yum -y --setopt=tsflags=nodocs install tesseract && \
	yum -y --setopt=tsflags=nodocs install tesseract-devel && \
    yum -y --setopt=tsflags=nodocs install tesseract-langpack-tur && \
    yum clean all

RUN yum -y --setopt=tsflags=nodocs install git && \
	yum clean all

RUN yum -y --setopt=tsflags=nodocs install python2-pip && \
	yum clean all

# python ocr tutorial
WORKDIR /opt
RUN	git clone https://github.com/kyilmaz80/python_ocr_tutorial/ && \
	cd /opt/python_ocr_tutorial/ && \
	pip install --upgrade pip && \
	pip install -r requirements.txt

WORKDIR /opt/python_ocr_tutorial/flask_server

EXPOSE 80
CMD ["python", "app.py"]

