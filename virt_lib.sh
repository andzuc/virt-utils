#!/bin/bash
set -euo pipefail

function virdump() {
    if ! command -v virsh >/dev/null 2>&1 ; then
	echo "$0: missing command virsh"
	exit 1
    fi
    if [ -z "$1" ]; then
	echo "$0: missing VM name"
	exit 1
    fi
    VM_NAME="$(virsh -c qemu:///system list --all --name|grep -i $1)"
    virsh -c qemu:///system dumpxml "$VM_NAME"
}

function virget() {
    if ! command -v xmlstarlet >/dev/null 2>&1 ; then
	echo "$0: missing command xmlstarlet"
	exit 1
    fi
    if [ -z "$2" ]; then
	echo "$0: missing xpath"
	exit 1
    fi
    virdump $1 \
    |xmlstarlet sel -t -v "$2"
}
