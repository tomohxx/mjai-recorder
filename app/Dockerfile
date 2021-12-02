FROM ruby:2.7
RUN gem install mjai mjai-manue pg
WORKDIR /src
ADD ./src /src
RUN chmod 755 entrypoint.sh analyze.rb 
ENTRYPOINT ["./entrypoint.sh"]
