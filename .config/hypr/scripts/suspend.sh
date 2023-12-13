#!/bin/bash

swayidle -w \
timeout 600 'hyprctl dispatch dpms off' \
timeout 7200 'swaylock --screenshots --clock --indicator --indicator-radius 150 --indicator-thickness 7 --effect-blur 4x2 --effect-vignette 0.5:0.5 --ring-color 00B0FF --key-hl-color E0F7FA --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2' \
timeout 8000 'loginctl suspend' \
resume 'hyprctl dispatch dpms on' \
before-sleep 'swaylock --screenshots --clock --indicator --indicator-radius 150 --indicator-thickness 7 --effect-blur 4x2 --effect-vignette 0.5:0.5 --ring-color 00B0FF --key-hl-color E0F7FA --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2 --fade-in 0.2'