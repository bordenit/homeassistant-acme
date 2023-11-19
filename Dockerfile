ARG BUILD_FROM
FROM $BUILD_FROM

apk add openssl
apk add socat
apk add git
apk add curl
apk add wget

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]