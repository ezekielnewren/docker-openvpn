FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y apt-file dumb-init supervisor jq
RUN apt-file update

RUN apt-get -y install ca-certificates wget net-tools gnupg
RUN wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -
RUN echo "deb http://as-repository.openvpn.net/as/debian jammy main">/etc/apt/sources.list.d/openvpn-as-repo.list
RUN apt-get update && apt-get install -y openvpn

COPY provision.sh /provision.sh

WORKDIR /docker
ENTRYPOINT ["dumb-init", "--", "bash", "-c"]
CMD ["/provision.sh && exec supervisord"]
