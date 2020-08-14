# 📡 PDS Engineering: Validate Action
# ===============================

# Container image that runs your code
FROM ubuntu:18.04


# Metadata
# --------

LABEL "com.github.actions.name"="PDS Validate"
LABEL "com.github.actions.description"="Validates PDS4 archival data"
LABEL "com.github.actions.icon"="flag"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/NASA-PDS/gh-action-pds-validate.git"
LABEL "homepage"="https://nasa-pds.github.io/validate/"
LABEL "maintainer"="Jordan Padams <jordan.h.padams@jpl.nasa.gov>"


# Image Details
# -------------

COPY entrypoint.sh /

RUN apt-get update && apt-get install -y \
curl wget default-jre-headless

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
