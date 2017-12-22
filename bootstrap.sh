#!/bin/bash

PROGNAME=$(basename $0)
VERSION="1.0"

export ANSIBLE_HOSTS=inventory/ansible_hosts
export ANSIBLE_HOST_KEY_CHECKING=False
export PYTHONPATH=/usr/local/lib/python3.5/dist-packages:/usr/local/src/this_project/credentials

usage() {
    echo "Usage: $PROGNAME [OPTIONS] FILE"
    echo
    echo "Options:"
    echo "  -h, --help          : show help. "
    echo "  --version           : show version. "
    echo "  --build-server      : you can build server that name you specified. "
    echo "  --deploy-all        : install middleware and deploy sources to the server you specified. "
    echo "  --deploy-source     : deploy sources to the server you specified. "
    echo
    exit 1
}

for OPT in "$@"
do
    case "$OPT" in
        '-h'|'--help' )
            usage
            exit 1
            ;;
        '--version' )
            echo $VERSION
            exit 1
            ;;
        '--build-server' )
            /usr/bin/ansible-playbook -i inventory gce.yml
            exit 1
            ;;
        '--deploy-all' )
            /usr/bin/ansible-playbook -i inventory deploy_all.yml
            exit 1
            ;;
        '--deploy-source' )
            /usr/bin/ansible-playbook -i inventory deploy_source.yml
            exit 1
            ;;
        '--'|'-' )
            shift 1
            param+=( "$@" )
            break
            ;;
        -*)
            echo "$PROGNAME: invalid options. -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done

if [ -z $param ]; then
    echo "$PROGNAME: too few arguments. " 1>&2
    echo "Try '$PROGNAME --help' you can see commands help. " 1>&2
    exit 1
fi
