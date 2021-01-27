FROM debian:stable-slim
MAINTAINER Alan Brenner <alan@abcompcons.com>

RUN cd /root && \
  curl -L -O https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz && \
  tar -xaf 3.6.0.tar.gz && \
  rm -f 3.6.0.tar.gz

ADD preloaded-vars.conf /root/ossec-hids-3.6.0/etc
RUN apt install -y libz-dev libssl-dev libpcre2-dev libevent-dev build-essential && \
  cd /root/ossec-hids-3.6.0 && \
  ./install.sh && \
  apt purge -y libz-dev libssl-dev libpcre2-dev libevent-dev build-essential

#
# Initialize the data volume configuration
#
ADD data_dirs.env /data_dirs.env
ADD init.bash /init.bash
# Sync calls are due to https://github.com/docker/docker/issues/9547
RUN chmod 755 /init.bash && /init.bash && rm /init.bash

#
# Add the bootstrap script
#
ADD run.bash /run.bash
RUN chmod 755 /run.bash

#
# Specify the data volume
#
VOLUME ["/var/ossec/data"]

# Expose ports for sharing
EXPOSE 514/ucp 514/tcp 1514/udp 1515/tcp

#
# Define default command.
#
ENTRYPOINT ["/run.bash"]
