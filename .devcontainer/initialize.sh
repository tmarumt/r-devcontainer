#!/bin/bash

volumes=("renv" "pip" "julia" "TinyTeX" "fonts" "pydrive2fs")

for vol in ${volumes[@]}; do
  if [ -z "$(docker volume ls -q -f name="$vol")" ]; then
    docker volume create $vol
  fi
done

repositories=("./")

for obj in ./personal/*/; do
  if [ -d "$obj" ] && [ "$(git -C "$obj" rev-parse --git-dir)" == ".git" ]; then
    repositories+=("$obj")
  fi
done

configurations=("user.name" "user.email")

for repo in ${repositories[@]}; do
  for config in ${configurations[@]}; do
    cur_config="$(git -C "$repo" config --get $config)"
    global_config="$(git -C "$repo" config --global --get $config)"
    local_config="$(git -C "$repo" config --local --get $config)"

    if [ -z "$local_config" ] && [ -n "$cur_config" ] && [ "$cur_config" != "$global_config" ]; then
      git -C "$repo" config --local $config "$cur_config"
    fi
  done
done
