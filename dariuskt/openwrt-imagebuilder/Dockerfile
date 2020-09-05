FROM nfqlt/debian-buster

ENV VERSION 19.07.3

ADD build /build
RUN bash /build/setup.sh && rm -Rf /build

CMD exec /entrypoint.sh

