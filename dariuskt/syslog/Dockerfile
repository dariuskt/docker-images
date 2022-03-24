FROM nfqlt/debian-bullseye


ADD build /build
RUN bash /build/setup.sh && rm -Rf /build

CMD exec /entrypoint.sh

