FROM ubuntu:17.10
RUN apt-get -y update && apt-get install -y apt-utils build-essential git libssl-dev libcurl4-openssl-dev libexpat-dev gettext
RUN bash -c '\
    set -e; \
    set -x; \
    # Version of git used on Jenkins CI \
    git clone --branch v2.13.2 --depth 1 https://github.com/git/git.git; \
    cd git; \
    [ "`git rev-parse --verify HEAD`" == "8c8e978f5719c6a58fb998742207bf907f963143" ]; \
    apt-get remove -y git; \
    make prefix=/usr install -j4; \
    [[ "`git --version`" =~ ^git\ version\ 2\.13\.2$ ]]; \
    '
RUN git config --global user.email "test@localhost"
RUN git config --global user.name "olcs-ci tester"
