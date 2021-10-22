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

FROM ubuntu:20.04

LABEL maintainer "Sam Massey <smassey@uk.ibm.com>"

RUN export DEBIAN_FRONTEND=noninteractive \
  # Install additional packages - do we need/want them all
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    bash \
    bc \
    ca-certificates \
    coreutils \
    curl \
    debianutils \
    file \
    findutils \
    gawk \
    grep \
    libc-bin \
    lsb-release \
    mount \
    passwd \
    procps \
    sed \
    tar \
    util-linux \
  && rm -rf /var/lib/apt/lists/* \
  # Optional: Update the command prompt with the MQ version
  && echo "mqldt" > /etc/debian_chroot \
  && sed -i 's/password\t\[success=1 default=ignore\]\tpam_unix\.so obscure sha512/password\t[success=1 default=ignore]\tpam_unix.so obscure sha512 minlen=8/' /etc/pam.d/common-password \
  && groupadd --system --gid 999 mqm \
  && useradd --system --uid 999 --gid mqm mqm \
  && useradd mqperf -G mqm \
  && echo mqperf:orland02 | chpasswd \
  && mkdir -p /home/mqperf/mqldt \
  && chown -R mqperf /home/mqperf/mqldt \
  && echo "cd ~/mqldt" >> /home/mqperf/.bashrc

COPY mqldt /home/mqperf/mqldt/
COPY *.sh /home/mqperf/mqldt/
USER mqperf
WORKDIR /home/mqperf/mqldt

ENV MQLDT_DIRECTORY=/var/mqldt
ENV MQLDT_NUMFILES=16
ENV MQLDT_FILESIZE=67108864
ENV MQLDT_DURATION=60
ENV MQLDT_CSVFILE=mqldt.csv
ENV MQLDT_QM=1

ENTRYPOINT ["./mqldtTest.sh"]
