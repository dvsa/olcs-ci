FROM centos:6.6
RUN yum install -y git
RUN bash -c '[[ "`git --version`" =~ ^git\ version\ 1\.7\. ]]'
RUN git config --global user.email "test@localhost"
RUN git config --global user.name "olcs-ci tester"
