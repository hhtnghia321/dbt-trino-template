# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    python3 \
    python3-pip \
    python3-dev \
    python3.12-venv \
    curl \
    vim \
    ssh \
    nano \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/app

RUN python3 -m venv /usr/app/venv
ENV PATH="/usr/app/venv/bin:$PATH"

#RUN python -m venv /opt/venv
#ENV PATH="/opt/venv/bin:$PATH" 
# Install any additional Python packages, if needed
# For example: RUN pip3 install numpy pandas
RUN pip install --upgrade pip setuptools wheel

RUN pip install --no-cache-dir \
    numpy \
    pandas \
    flask \
    dbt-core \
    dbt-trino \
    psycopg2-binary

# Create dbt profile directory
RUN mkdir -p /root/.dbt

# Set environment variables
ENV DBT_PROFILES_DIR=/root/.dbt


# Create project directory
RUN mkdir -p /usr/app/dbt

# Set the working directory to the project directory
WORKDIR /usr/app/dbt

# Create the raffle_shop project during build
RUN dbt init raffle_shop --skip-profile-setup

# Expose a port if your app runs a server (optional)
EXPOSE 5000

# Set the default command (optional)
# CMD ["bash"]
CMD ["/usr/app/dbt"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=3 \
  CMD /usr/app/venv/bin/dbt --version || exit 1
