FROM python:3.11-bookworm

RUN apt-get update \
  && apt-get install -y python3-dev \
                        gcc \
                        ffmpeg \
                        libc-dev \
                        zip \
  && apt-get purge --autoremove -y git \
                                   wget \
  && apt-get -y upgrade \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# working directory
WORKDIR /src

# copy requirement file to working directory
COPY requirements.txt .
RUN --mount=type=secret,id=fiftyone_pypi_token \
  FIFTYONE_PYPI_TOKEN=$(cat /run/secrets/fiftyone_pypi_token) \
  pip install -r requirements.txt

# Fiftyone by default installs a mongo from ubuntu 18.04
# to run local tests against.  We need to remove that
# and put a more modern one in there.
RUN pip uninstall -y fiftyone-db \
  && pip install fiftyone-db-ubuntu2204 --force-reinstall

# Upgrade FiftyOne DB
RUN FIFTYONE_DATABASE_ADMIN=true fiftyone migrate --all

COPY . .
