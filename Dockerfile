FROM ruby:2.4.4

ENV TZ Asia/Tokyo

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        default-libmysqlclient-dev \
        mysql-client \
        apt-utils \
        xvfb \
        wget \
        curl \
    \
    && rm -rf /var/lib/apt/lists/*

# Setup Chrome driver
RUN apt-get update \
    && apt-get install -y unzip \
    && CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
    && wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ \
    && unzip ~/chromedriver_linux64.zip -d ~/ \
    && rm ~/chromedriver_linux64.zip \
    && chown root:root ~/chromedriver \
    && chmod 755 ~/chromedriver \
    && mv ~/chromedriver /usr/bin/chromedriver \
    && sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# Setup node
ENV NODE_VERSION=8.x
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | bash \
    && apt-get install -y nodejs

# Setup yarn
ENV PATH /root/.yarn/bin:$PATH
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 0.28.4
