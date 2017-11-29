FROM ruby:2.2.3

RUN apt-get update -qq

# Setup node
ENV NODE_VERSION=8.x
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | bash \
    && apt-get install -y nodejs

# Setup yarn
ENV PATH /root/.yarn/bin:$PATH
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
