FROM ubuntu:17.10
RUN apt-get -y update
RUN apt-get install -y apt-utils
RUN apt-get install -y git
# more recent version of git likely to be found on dev's machines. Should be safe to update whenever required
RUN bash -c '[[ "`git --version`" =~ ^git\ version\ 2\.14\. ]]'
RUN git config --global user.email "test@localhost"
RUN git config --global user.name "olcs-ci tester"
