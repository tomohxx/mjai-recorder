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
    "mjai-manue --name=Manue1_1" \
    "mjai-manue --name=Manue1_2" \
    "mjai-manue --name=Manue1_3"
  ./analyze.rb
done
