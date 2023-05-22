#
# Stage 1
#
FROM debian:11-slim AS build

# Install system requirements for Python and Python virtual environment
RUN apt-get update \
  && apt-get install --no-install-suggests --no-install-recommends --yes \
    python3-venv \
    gcc \
    libpython3-dev \
  && python3 -m venv /venv \
  && /venv/bin/pip install --upgrade pip setuptools wheel

# Install Python requirements
COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

#
# Stage 2
#
FROM gcr.io/distroless/python3-debian11

COPY --from=build /venv /venv

COPY fulcrum-monitor.py /

ENTRYPOINT ["/venv/bin/python3"]

CMD ["/fulcrum-monitor.py"]
