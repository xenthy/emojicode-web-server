FROM ubuntu:20.10

# Change sources list to use a server in Singapore
RUN sed -i 's/archive.ubuntu.com/mirror.0x.sg/' /etc/apt/sources.list

# Install dependacies
RUN apt-get update -qq \
    && apt-get -y --no-install-recommends install \
    ca-certificates \
    g++ \
    rsync \
    wget \
    libncurses5 

# Cleanup
RUN \
    apt-get remove -y &&\
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* > /dev/null 2>&1

# Directory for the program
WORKDIR /ict2206

# Copy source code
COPY / /ict2206

ENV TERM xterm

# Install Emojicode
RUN mkdir -p /root/emojicode \
    && wget -q https://github.com/emojicode/emojicode/releases/download/v1.0-beta.2/Emojicode-1.0-beta.2-Linux-x86_64.tar.gz -O emojicode.tar.gz \
    && tar -xzf emojicode.tar.gz --directory /root/emojicode --strip-components=1 \
    && rm emojicode.tar.gz \
    && cd /root/emojicode \
    && echo y | ./install.sh \
    && cd  \
    && rm -r /root/emojicode

# Compile the program
RUN emojicodec --color src/main.emojic

# Run the program
CMD [ "./src/main" ]