#!/bin/bash

show_help()
{
cat << ENDHELP
usage: create_peer [options]
Options:
    --provider=<PROVIDER>
        Choose provider. Supported providers are: libvirt, vmware_desktop, virtualbox, parallels and hyperv. Default: libvirt
    --box=<BOX>
        Use boxe subutai/stretch or subutai/stretch-master. Default: subutai/stretch
    --subutai_env=<SUBUTAI_ENV>
        Set subutai environment. You can set sysnet, dev, master and prod. Default: master
    --peer_dir=<PEER_DIR>
        Set the peer creation path. Default: ~/peer
    --help
    Display help
ENDHELP
}


PROVIDER=libvirt
BOX="subutai/stretch-master"
SUBUTAI_ENV="master"
PEER_DIR=~/peer

while [ $# -ge 1 ]; do
    case "$1" in
        --provider=*)
            PROVIDER="`echo ${1} | awk '{print substr($0,12)}'`" ;;
        --box=*)
            BOX="`echo ${1} | awk '{print substr($0,7)}'`" ;;
        --subutai_env=*)
            SUBUTAI_ENV="`echo ${1} | awk '{print substr($0,15)}'`" ;;
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

rm -rf $PEER_DIR/$PROVIDER
mkdir -p $PEER_DIR/$PROVIDER
cd $PEER_DIR/$PROVIDER

vagrant init $BOX
SUBUTAI_ENV=$SUBUTAI_ENV vagrant up --provider $PROVIDER
