FROM node:8.15-jessie-slim as BUILDER
ARG APP_NAME
ARG ENVIRONMENT
ADD . /${APP_NAME}
RUN mkdir -p /${APP_NAME}-deploy/
RUN deploy/build_k8s.sh /${APP_NAME}-deploy ${ENVIRONMENT}


FROM node:8-slim as RUNNER
ARG APP_NAME
ENV destination='/home/ubuntu/deployment'
COPY --from=BUILDER /${APP_NAME}-deploy/  ${destination}
COPY --from=BUILDER /${APP_NAME}-deploy/deploy/${APP_NAME}.supervisor.conf /etc/supervisor.conf
RUN apt-get update && apt-get install supervisor -y
RUN npm install -g typescript
RUN mkdir -p /logs/${APP_NAME}
CMD ["/usr/bin/supervisord", "-n",  "-c",  "/etc/supervisor.conf"]
