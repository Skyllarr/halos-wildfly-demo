#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

VERSION=0.0.1

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
readonly script_dir
cd "${script_dir}"

usage() {
  cat <<EOF
USAGE:
    $(basename "${BASH_SOURCE[0]}") [FLAGS]

FLAGS:
    -h, --help      Prints help information
    -v, --version   Prints version information
    --no-color      Uses plain text output
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    # shellcheck disable=SC2034
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

version() {
  msg "${BASH_SOURCE[0]} $VERSION"
  exit 0
}

parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --version) version ;;
    --no-color) NO_COLOR=1 ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done
  return 0
}

parse_params "$@"
setup_colors
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-store=twoWayKS:add(path=server.keystore.jks,relative-to=jboss.server.config.dir,credential-reference={clear-text=t4J887sx4wmeaPWWsDXZqBsdJtb92szA},type=JKS)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-store=twoWayKS:generate-key-pair(alias=localhost,algorithm=RSA,key-size=2048,validity=365,not-before="2022-10-01 01:02:03",credential-reference={clear-text=t4J887sx4wmeaPWWsDXZqBsdJtb92szA},distinguished-name="CN=localhost")'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-store=twoWayKS:store()'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-store=twoWayKS:export-certificate(alias=localhost,path=server.cer,relative-to=jboss.server.config.dir,pem=true)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-store=twoWayTS:add(path=server.truststore.jks,relative-to=jboss.server.config.dir,credential-reference={clear-text=t4J887sx4wmeaPWWsDXZqBsdJtb92szA},type=JKS)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-store=twoWayTS:import-certificate(alias=client,path=/Users/hpehl/dev/hal/halos/wildfly-demo/client.cer,credential-reference={clear-text=_HRW97eMN337GuyzMKWecW9pgnP_QZgx},trust-cacerts=true,validate=false)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-store=twoWayTS:store()'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/key-manager=twoWayKM:add(key-store=twoWayKS,credential-reference={clear-text=t4J887sx4wmeaPWWsDXZqBsdJtb92szA})'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/trust-manager=twoWayTM:add(key-store=twoWayTS)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/subsystem=elytron/server-ssl-context=twoWaySSC:add(key-manager=twoWayKM,protocols=["TLSv1.2"],trust-manager=twoWayTM,want-client-auth=true,need-client-auth=true)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/core-service=management/management-interface=http-interface:write-attribute(name=ssl-context, value=twoWaySSC)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='/core-service=management/management-interface=http-interface:write-attribute(name=secure-socket-binding, value=management-https)'
wildfly-27.0.0.Beta1/bin/jboss-cli.sh -c --command='reload'