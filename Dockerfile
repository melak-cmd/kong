FROM kong
LABEL description="Kong, kong-oidc plugin"
USER root
LABEL maintainer="Amine KAOUANI"
RUN apk update && apk add git jq unzip luarocks
RUN luarocks install kong-oidc      
USER 1001
