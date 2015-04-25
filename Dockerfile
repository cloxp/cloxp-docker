FROM          node
MAINTAINER    Robert Krahn <robert.krahn@gmail.com>

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; \
    apt-get install -y \
    python-software-properties \
    curl wget git \
    less manpages manpages-dev \
    openssl sudo \
    lsof dnsutils aspell unzip zip

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# java...!
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list; \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886; \
    apt-get update

# auto accept oracle jdk license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections; \
    apt-get install -y oracle-java8-installer ca-certificates

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get -y install maven

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

RUN /usr/sbin/useradd \
    --create-home --home-dir /home/cloxp \
     --shell /bin/bash \
     --groups sudo \
     --password $(openssl passwd -1 "cloxp") \
     cloxp

# nodejs tooling
RUN npm install forever -g

# lively
ENV WORKSPACE_LK=/home/cloxp/LivelyKernel \
    HOME=/home/cloxp

USER cloxp

ADD gitconfig /home/cloxp/.gitconfig

RUN mkdir /home/cloxp/bin
ENV PATH=$HOME/bin:$PATH

WORKDIR /home/cloxp/

# leiningen
RUN mkdir -p $HOME/bin; \
  cd $HOME/bin; \
  wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein; \
  chmod a+x lein; \
  ./lein

# cloxp
ENV CLOXP_VERSION=pre-0.0.8
RUN wget "https://github.com/cloxp/cloxp-install/archive/$CLOXP_VERSION.zip";
RUN unzip "$CLOXP_VERSION.zip"; \
  cd "cloxp-install-$CLOXP_VERSION"; \
  ./install.sh; \
  mv LivelyKernel ../;\
  cd ..; \
  rm -rf "cloxp-install-$CLOXP_VERSION"; rm "$CLOXP_VERSION.zip";

WORKDIR /home/cloxp/LivelyKernel

EXPOSE 10080 10082 10083 10083 10084 10085 10086 10087 10088 10089

CMD rm *.pid; \
  forever bin/lk-server.js -p 10080 --host 0.0.0.0 --db-config '{"enableRewriting":false}'
