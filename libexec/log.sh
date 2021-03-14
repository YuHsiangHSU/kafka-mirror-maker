#!/usr/bin/env bash

date_cmd=$(which date)
[[ ! -e $date_cmd ]] && date_cmd="/bin/date"

function _tstamp() {
    _ts=$($date_cmd +'%F %T')
    echo "$_ts [$(hostname)]"
}

if [[ ${TERM} == "" || ${TERM} == "unknown" ]]; then
    export TERM="xterm"
fi

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
white=$(tput setaf 7)

function _format() {
    _ts=$(_tstamp)
    _bn=$(basename $0)
    _func="${FUNCNAME[2]}"
    _pid=$$
    echo "${_color} $_ts $_pid $_sev ($_bn) [$_func] $*"

}

function log_fatal() {
    _color=$white
    _sev="FATAL"
    _format $* >&2
}
function log_error() {
    _color=$red
    _sev="ERROR"
    _format $* >&2
}
function log_warn() {
    _color=$yellow
    _sev="WARN"
    _format $* >&1
}
function log_info() {
    _color=$white
    _sev="INFO"
    _format $* >&1
}
function log_debug() {
    _color=$white
    _sev="DEBUG"
    _format $* >&1
}
