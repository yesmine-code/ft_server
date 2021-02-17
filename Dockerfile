FROM debian:buster

COPY srcs /files

RUN chmod u+x /files/start.sh

CMD bash /files/start.sh && bash

EXPOSE 80 443
