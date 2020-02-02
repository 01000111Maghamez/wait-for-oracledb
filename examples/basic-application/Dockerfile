FROM debian:10

WORKDIR /app

RUN apt-get update && \
    apt-get install -y unzip curl libaio1 && \
    curl -s https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basiclite-linux.x64-19.5.0.0.0dbru.zip --output instantclient-basiclite.zip && \
    curl -s https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-sqlplus-linux.x64-19.5.0.0.0dbru.zip --output instantclient-sqlplus.zip && \
    unzip instantclient-basiclite.zip && rm instantclient-basiclite.zip && \
    unzip instantclient-sqlplus.zip && rm instantclient-sqlplus.zip && \
    mv instantclient_19_5 /opt/instantclient_19_5 && \
    echo 'export LD_LIBRARY_PATH=/opt/instantclient_19_5:$LD_LIBRARY_PATH' >> /root/.bashrc && \
    echo 'export PATH=/opt/instantclient_19_5:$PATH' >> /root/.bashrc

ENV LD_LIBRARY_PATH=/opt/instantclient_19_5:$LD_LIBRARY_PATH
ENV PATH=/opt/instantclient_19_5:$PATH

COPY startup.sh .