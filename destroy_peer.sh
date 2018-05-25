#!/bin/bash

show_help()
{
cat << ENDHELP
usage: destroy_peer [options]
Options:
    --provider=<PROVIDER>
        Choose provider. Supported providers are: libvirt, vmware_desktop, virtualbox, parallels and hyperv. Default: libvirt
    --peer_dir=<PEER_DIR>
        Set the peer path. Default: ~/peer
    --help
    Display help
ENDHELP
}


PROVIDER=libvirt
PEER_DIR=~/peer

while [ $# -ge 1 ]; do
    case "$1" in
        --provider=*)
            PROVIDER="`echo ${1} | awk '{print substr($0,12)}'`" ;;
        --peer_dir=*)
            PEER_DIR="`echo ${1} | awk '{print substr($0,12)}'`" ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "ERROR: Unknown argument: $1"
            show_help
            exit 1
            ;;
    esac

    shift
done

if [ -d "$PEER_DIR/$PROVIDER" ]; then
  cd $PEER_DIR/$PROVIDER
  # First do unregister peer from Bazaar
  vagrant subutai deregister
  vagrant destroy -f

  if [ "$?" -ne 0 ]; then
    rm -rf .vagrant
    rm -rf $PEER_DIR/$PROVIDER
  fi
else
  echo "Peer not found in $PEER_DIR/$PROVIDER"
fi
