# you can try replacing "debian:sid" with "debian:testing" or "ubuntu:latest".
# For Ubuntu, replace -J with -j in the "aflize" script.
FROM ubuntu:trusty

# If you'd like to specify a list of packages to be built, uncomment the
# following line by removing the # symbol at its beginning:
# ADD ./packages.list /root/

RUN \
    apt-get update \
        --quiet \
    && apt-get install \
        --yes \
        --no-install-recommends \
        --no-install-suggests \
        build-essential \
        gcc \
        g++ \
        wget \
        ca-certificates \
        procps \
        tar \
        gzip \
        make \
        vim \
        git \
        gdb \
        golang \
        clang \
        llvm \
        libtool \
        libtool-bin \
        bison \
        automake \
        libglib2.0-dev \
        
RUN wget 'http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz' -O- | tar zxvf - && cd afl-* && make PREFIX=/usr install

# Make sure afl-gcc will be run. This forces us to set AFL_CC and AFL_CXX or
# otherwise afl-gcc will be trying to call itself by calling gcc.
ADD ./afl-sh-profile /etc/profile.d/afl-sh-profile
RUN ln -s /etc/profile.d/afl-sh-profile /etc/profile.d/afl-sh-profile.sh

# It looks like /etc/profile.d isn't read for some reason, but .bashrc is.
# Let's include /etc/profile.d/afl-sh-profile from there.
RUN echo '. /etc/profile.d/afl-sh-profile' >> /root/.bashrc && chmod +x /root/.bashrc

RUN chmod +x /etc/profile.d/afl-sh-profile
ADD ./setup-afl_cc /usr/bin/setup-afl_cc
RUN chmod +x /usr/bin/setup-afl_cc && /usr/bin/setup-afl_cc

ADD ./afl-fuzz-parallel /usr/bin/

ADD ./install-preeny.sh /tmp/
RUN chmod +x /tmp/install-preeny.sh && /tmp/install-preeny.sh

RUN mkdir ~/pkg ~/pkgs ~/logs

# This isn't really necessary, but it'd be a real convenience for me.
RUN apt-get update && apt-get install apt-file -y && apt-file update

# install "exploitable" GDB script
RUN apt-get update && apt-get install gdb python-setuptools -y
#RUN wget -O- 'https://github.com/jfoote/exploitable/archive/master.tar.gz' | tar zxvf - && cd exploitable-master && python setup.py install

# install "Crashwalk" set path to exploitable.py

ADD ./crashwalk.sh /tmp/
RUN chmod +x /tmp/crashwalk.sh && /tmp/crashwalk.sh

RUN mkdir ~/fuzz-results ~/pkgs-coverage
RUN apt-get install lcov -y
ADD ./testcases /root/testcases
ADD ./fuzz-pkg-with-coverage.sh /root/
RUN chmod +x /root/fuzz-pkg-with-coverage.sh
ADD ./aflize /usr/bin/aflize

# Add some of the settings I find it hard to live without.
RUN echo "alias ls='ls --color=auto'" >> /root/.bashrc
RUN echo "syntax on" >> /root/.vimrc

#Setup qemu and llvm_mode
ADD ./qemu-llvm.sh /tmp/
RUN chmod +x /tmp/qemu-llvm.sh && /tmp/qemu-llvm.sh
