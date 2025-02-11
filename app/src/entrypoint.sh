#!/bin/sh
while true
do
  mjai server \
    --host=0.0.0.0 \
    --port=11600 \
    --game_type=one_kyoku \
    --room=default \
    --games=1 \
    --log_dir="/log_dir" \
    "./run_manue.sh" \
    "./run_manue.sh" \
    "./run_manue.sh"
  ./analyze.rb
done
