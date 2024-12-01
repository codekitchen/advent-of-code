#!/bin/bash

# https://www.reddit.com/r/adventofcode/comments/105iu5u/on_crafting_animated_visualizations/

# ffmpeg -r 30 -i viz/frame-%04d.png video.mp4

/Users/brianp/programming/advent-of-code/2023/16/16.rb example  -v
2023/16/viz.rb <viz/16_part1_example.dump >viz/16_part1_example.json
opal -c -o viz_canvas.js viz_canvas.rb
open http://127.0.0.1:9090/viz_canvas.html
ruby -run -e httpd . -p 9090
