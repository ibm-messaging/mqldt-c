# © Copyright IBM Corporation 2015, 2017
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM registry.access.redhat.com/ubi9/ubi:latest

LABEL maintainer "Sam Massey <smassey@uk.ibm.com>"

RUN dnf install -y wget bc file procps procps iputils vim file \
  && dnf -y update \
  && dnf clean all \
  && groupadd --gid 30000 mqm \
  && useradd --uid 30000 --gid mqm mqperf \
  && mkdir -p /home/mqperf/mqldt \
  && chmod 777 /home/mqperf/mqldt \
  && chown -R mqperf /home/mqperf/mqldt \
  # Update the command prompt with the container name, login and cwd
  && echo "export PS1='mqldt:\u@\h:\w\$ '" >> /home/mqperf/.bashrc \
  && echo "cd ~/mqldt" >> /home/mqperf/.bashrc

USER 30000
COPY mqldt /home/mqperf/mqldt/
COPY *.sh /home/mqperf/mqldt/
WORKDIR /home/mqperf/mqldt

ENV MQLDT_DIRECTORY=/var/mqldt
ENV MQLDT_NUMFILES=16
ENV MQLDT_FILESIZE=67108864
ENV MQLDT_DURATION=60
ENV MQLDT_CSVFILE=mqldt.csv
ENV MQLDT_QM=1
ENV MQLDT_BLOCKSIZE=128K

ENTRYPOINT ["./mqldtTest.sh"]
