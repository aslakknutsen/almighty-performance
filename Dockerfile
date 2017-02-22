FROM centos:7
MAINTAINER "Konrad Kleine <kkleine@redhat.com>"
ENV LANG=en_US.utf8

# Some packages might seem weird but they are required by the RVM installer.
RUN yum install -y \
      findutils \
      git \
      golang \
      make \
      mercurial \
      procps-ng \
      tar \
      wget \
      which \
    && yum clean all

ENV ALMIGHTY_INSTALL_PREFIX=/usr/local/alm
RUN mkdir -p ${ALMIGHTY_INSTALL_PREFIX}

ENV ALMIGHTY_USER_NAME=almighty
RUN useradd --no-create-home -s /bin/bash ${ALMIGHTY_USER_NAME}

ADD targets ${ALMIGHTY_INSTALL_PREFIX}/targets
ADD run.sh ${ALMIGHTY_INSTALL_PREFIX}/run.sh
RUN chmod +x ${ALMIGHTY_INSTALL_PREFIX}/run.sh
RUN chmod -R 777 ${ALMIGHTY_INSTALL_PREFIX}

USER ${ALMIGHTY_USER_NAME}
WORKDIR ${ALMIGHTY_INSTALL_PREFIX}

ENV GOPATH ${ALMIGHTY_INSTALL_PREFIX}
ENV PATH $PATH:$GOPATH/bin

RUN go get -u github.com/tsenart/vegeta

ENV RATE 10
ENV DURATION 10s

ENTRYPOINT ["sh", "run.sh"]
