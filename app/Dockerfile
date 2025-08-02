FROM ruby:3.3.9
RUN apt-get update && \
  apt-get install -y nodejs npm --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*
RUN gem install mjai pg
WORKDIR /src
RUN git clone https://github.com/gimite/mjai-manue.git
RUN cd mjai-manue/coffee && \
  npm install -g coffeescript@1.12.7 && \
  npm install glob@11.0.1 printf@0.6.1 seed-random@2.2.0
COPY ./src/* /src/
RUN chmod 755 entrypoint.sh analyze.rb
ENTRYPOINT ["./entrypoint.sh"]
