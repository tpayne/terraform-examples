#!/bin/sh
command=$(basename $0)
direct=$(dirname $0)
trap 'stty echo; echo "${command} aborted"; exit' 1 2 3 15
#
CWD=$(pwd)

tmpFile="/tmp/tmpFile$$.tmp"
param1=
param2=
param3=

rmFile() {
	if [ -f "$1" ]; then
		(rm -f "$1") >/dev/null 2>&1
	fi
	return 0
}
#
# Usage
#
usage() {
	#

	while [ $# -ne 0 ]; do
		case $1 in
		-p1 | --param1)
			param1=$2
			shift 2
			;;
		-p2 | --param2)
			param2=$2
			shift 2
			;;
		-p3 | --param3)
			param3=$2
			shift 2
			;;
		--debug)
			set -xv
			shift
			;;
		-d | --delete)
			remove=1
			shift
			;;
		-?*)
			show_usage
			break
			;;
		--)
			shift
			break
			;;
		- | *) break ;;
		esac
	done

	if [ "x${param1}" = "x" ]; then
		echo "${command}: Error: You must specify a parameter"
		return 1
	fi
	
	return 0
}

show_usage() {
	echo "${command}:"
	echo "${command}: Usage"
	echo "${command}:     -p1,--param1 <param>"
	echo "${command}:     -p2,--param2 <param>"
	echo "${command}:     -p3,--param3 <param>"
	echo "${command}:"

	exit 0
}

printOut() {
	echo "${command}: Print params"
	echo "${command}:"
	echo "${command}: ${1}"
	echo "${command}: ${2}"
	echo "${command}: ${3}"
	echo ""
	return 0
}

usage $*
if [ $? -ne 0 ]; then
	echo "${command}: - Usage error"
	show_usage
	exit 1
fi

printOut ${param1} ${param2} ${param3}
if [ $? -ne 0 ]; then
	echo "${command}: - Printout error"
	exit 1
fi

rmFile "${tmpFile}"

exit 0
