# Small base image
FROM alpine

# Upgrade the OS, install the IBM Cloud CLI and Code Engine plugin
RUN apk update && apk upgrade && apk add bash curl jq git ncurses
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | bash && \
    ln -s /usr/local/bin/ibmcloud /usr/local/bin/ic && \
    ibmcloud plugin install code-engine

# Copy over the actual script
COPY script.sh /script.sh

WORKDIR /app

ENTRYPOINT [ "/script.sh" ]