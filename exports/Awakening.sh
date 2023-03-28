#!/bin/sh
echo -ne '\033c\033]0;Awakening\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Awakening.x86_64" "$@"
