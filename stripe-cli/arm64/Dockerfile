FROM alpine
ENV STRIPE_SLI_VERSION 1.8.6
RUN apk update && apk upgrade && \
  apk add --no-cache ca-certificates curl && \
  curl -L https://github.com/stripe/stripe-cli/releases/download/v${STRIPE_SLI_VERSION}/stripe_${STRIPE_SLI_VERSION}_mac-os_arm64.tar.gz --output /tmp/stripe_${STRIPE_SLI_VERSION}_mac-os_arm64.tar.gz && \
  cd /tmp && \
  tar -xzf stripe_${STRIPE_SLI_VERSION}_mac-os_arm64.tar.gz && rm stripe_${STRIPE_SLI_VERSION}_mac-os_arm64.tar.gz && \
  chmod a+x stripe && mv stripe /bin/stripe
ENTRYPOINT ["/bin/stripe"]