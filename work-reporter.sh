#!/usr/bin/env bash

__work_reporter::red() {
  printf "\e[31m"
}

__work_reporter::reset() {
  printf "\e[m"
}

__work_reporter::print_error_label() {
  __work_reporter::red
  printf "Error: "
  __work_reporter::reset
}

__work_reporter::url_encode() {
  echo "$1" | nkf -WwMQ | tr = %
}

__work_reporter::help() {
  if (( $# == 0 )); then
    __work_reporter::print_error_label
    printf "Wrong number of arguments. Expected 1, got $#\n"
  elif [[ $1 != "help" ]]; then
    __work_reporter::print_error_label
    printf "Unexpected subcommand. got $1\n"
  fi

  cat <<-HELP
	Usage:
	  work [COMMAND]

	Commands:
	  - start	Start working and record working time.
	  - stop(end)	End working and report working time.

	Config

	  .bashrc

	  export SLACK_API_TOKEN="xoxp-00000000000-00000000000-000000000000-0123456789abcdefghijklmnopqrstuv"
	  export SLACK_START_STATUS_TEXT="お仕事なう"
	  export SLACK_START_EMOJI=":muscle:"
	  export SLACK_END_STATUS_TEXT="おやすみ"
	  export SLACK_END_EMOJI=":zzz:"

	Options:
	  -h, --help Show help message

	Author:		maxmellon
HELP
  return 1
}

__work_reporter::slack_status_to_start() {
  local URL="https://slack.com/api/users.profile.set"
  local STATUS_TEXT=$(__work_reporter::url_encode $SLACK_START_STATUS_TEXT)
  local EMOJI=$(__work_reporter::url_encode $SLACK_START_EMOJI)
  URL="$URL?token=$SLACK_API_TOKEN"
  URL="$URL&profile=%7B%22status_text%22%3A%22$STATUS_TEXT"
  URL="$URL%22%2C%22status_emoji%22%3A%22$EMOJI%22%7D"
  curl -X POST "$URL" > /dev/null 2>&1 && true || false
}
__work_reporter::slack_status_to_end() {
  local URL="https://slack.com/api/users.profile.set"
  local STATUS_TEXT=$(__work_reporter::url_encode $SLACK_END_STATUS_TEXT)
  local EMOJI=$(__work_reporter::url_encode $SLACK_END_EMOJI)
  URL="$URL?token=$SLACK_API_TOKEN"
  URL="$URL&profile=%7B%22status_text%22%3A%22$STATUS_TEXT"
  URL="$URL%22%2C%22status_emoji%22%3A%22$EMOJI%22%7D"
  curl -X POST "$URL" > /dev/null 2>&1 && true || false
}

__work_reporter::start() {
  printf "Start working at " && date
  export __work_reporter_STATE="START"
  export __work_reporter_START_TIME=$(date +%s)
  __work_reporter::slack_status_to_start && true || false
}

__work_reporter::end() {
  printf "End working at " && date
  export __work_reporter_STATE="STOP"
  export __work_reporter_END_TIME=$(date +%s)
  local diff=$(expr $__work_reporter_END_TIME - $__work_reporter_START_TIME)
  local result=$(expr $diff / 60)
  printf "$result min\n"
  __work_reporter::slack_status_to_end && true || false
}

work() {
  case $# in
    0 )
      __work_reporter::help || return 1
    ;;
    * )
      case $1 in
        'start' )
          __work_reporter::start
          ;;
        'end'|'stop' )
          __work_reporter::end
          ;;
        '-h'|'--help' )
          __work_reporter::help "help" || return 0
          ;;
        * )
          __work_reporter::help $1 || return 1
          ;;
      esac
    ;;
  esac
}

export __work_reporter_STATE="STOP"

# vim: ft=zsh sw=2 et
