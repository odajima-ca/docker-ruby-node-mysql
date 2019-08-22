FROM ruby:2.4.4

ENV TZ Asia/Tokyo

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      default-libmysqlclient-dev \
      mysql-client \
      apt-utils \
      xvfb \
    \
    && rm -rf /var/lib/apt/lists/*

# Install the latest versions of Google Chrome and Chromedriver:
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install \
        unzip \
    && \
        DL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && curl -sL "$DL" > /tmp/chrome.deb \
    && apt install --no-install-recommends --no-install-suggests -y \
        /tmp/chrome.deb \
    && CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage' \
    # Patch Chrome launch script and append CHROMIUM_FLAGS to the last line:
    && sed -i '${s/$/'" $CHROMIUM_FLAGS"'/}' /opt/google/chrome/google-chrome \
    && BASE_URL=https://chromedriver.storage.googleapis.com \
    && VERSION=$(curl -sL "$BASE_URL/LATEST_RELEASE") \
    && curl -sL "$BASE_URL/$VERSION/chromedriver_linux64.zip" -o /tmp/driver.zip \
    && unzip /tmp/driver.zip \
    && mv chromedriver /usr/local/bin/ \
    # Remove obsolete files:
    && apt-get autoremove --purge -y \
        unzip \
    && apt-get clean \
    && rm -rf \
        /tmp/* \
        /usr/share/doc/* \
        /var/cache/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# Setup node
ENV NODE_VERSION=8.x
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | bash \
    && apt-get install -y nodejs

# Setup yarn
ENV PATH /root/.yarn/bin:$PATH
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 0.28.4
