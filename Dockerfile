# Copyright 2020 Linaro Limited
#

FROM ubuntu:18.04

RUN apt-get clean && apt-get update

# software-properties for add-apt-repository
# locales for LANG support
# sudo to make life easier when running as build user
# vim.tiny so we have an editor
RUN apt-get install -y --no-install-recommends software-properties-common \
	locales sudo vim.tiny

# The package sets are based on Yocto & crosstool-ng docs/references:
#
# Yocto:
# https://www.yoctoproject.org/docs/2.3.4/ref-manual/ref-manual.html#ubuntu-packages
#
# crosstool-ng:
# https://github.com/crosstool-ng/crosstool-ng/blob/master/testing/docker/ubuntu18.04/Dockerfile
#
# Limiting to python2 for mbed packages
RUN apt-get install -y --no-install-recommends python-pip python-dev xz-utils file python-setuptools libusb-1.0

# Install greentea
RUN pip install wheel
CMD python setup.py bdist_wheel
RUN pip install mbed-greentea

COPY test_spec.json .

CMD mbedgt --test-spec test_spec.json -n logging.log_list -V --sync=0

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
