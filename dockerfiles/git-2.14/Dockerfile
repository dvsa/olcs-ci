FROM ubuntu:17.10
RUN apt-get -y update
RUN apt-get install -y apt-utils
RUN apt-get install -y git
RUN bash -c '[[ "`git --version`" =~ ^git\ version\ 2\.14\. ]]'
RUN git config --global user.email "test@localhost"
RUN git config --global user.name "olcs-ci tester"
