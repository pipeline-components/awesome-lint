FROM pipelinecomponents/base-entrypoint:0.2.0 as entrypoint

FROM node:12.18.2-alpine
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD awesome-lint

WORKDIR /app/

# Generic
#RUN apk add --no-cache
COPY app /app/

# Node
ENV PATH "$PATH:/app/node_modules/.bin/"
RUN yarn install --frozen-lockfile && yarn cache clean

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Awesome-lint in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Awesome-lint" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/awesome-lint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/awesome-lint/" \
    org.label-schema.vendor="Pipeline Components"
