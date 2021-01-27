FROM debian:stable-slim

ARG email_addr=test@example.com

RUN apt-get update && apt-get install -y curl && \
  cd /root && \
  curl -L -O https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz && \
  tar -xaf 3.6.0.tar.gz && \
  rm -f 3.6.0.tar.gz

ADD preloaded-vars.conf /root/ossec-hids-3.6.0/etc/preloaded-vars.conf
RUN apt-get install -y libz-dev libssl-dev libpcre2-dev libevent-dev build-essential && \
  cd /root/ossec-hids-3.6.0 && \
  sed -i -e s/test@example.com/${email_addr}/ etc/preloaded-vars.conf && \
  cat etc/preloaded-vars.conf && \
  ./install.sh && \
  apt-get purge -y libz-dev libssl-dev libpcre2-dev libevent-dev build-essential && \
  apt-get autoremove -y && apt-get clean

#
# Initialize the data volume configuration
#
ADD data_dirs.sh /data_dirs.sh
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
EXPOSE 514/udp 514/tcp 1514/udp 1515/tcp

#
# Define default command.
#
ENTRYPOINT ["/run.bash"]
