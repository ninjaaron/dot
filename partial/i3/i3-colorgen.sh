#!/usr/bin/env bash

theme=$(cat ~/.theme)
source ~/.themes/"$theme"

cat ~/.i3/base > ~/.i3/config

cat >> ~/.i3/config << EOF
# Style
font ${font2:-bitocra 7}
# class                 border  backgr. text    indicator child_border
client.focused          $bg_color ${frame_border_active_color:-$bg_color} ${window_title:-$fg_color} ${window_title:-$fg_color} ${frame_border_active_color:-$bg_color}
client.focused_inactive ${window_border_i:-$bg_color} ${window_border_i:-$bg_color} ${window_title_i:-$dark_grey} $bg_color ${window_border_i:-$bg_color}
client.unfocused        ${window_border_i:-$bg_color} ${window_border_i:-$bg_color} ${window_title_i:-$dark_grey} $bg_color ${window_border_i:-$bg_color}

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
  status_command i3status -c ~/.i3/bar
  position top
  colors {
    background         ${panel_bg:-$bg_color}
    statusline         ${panel_fg:-$fg_color}
    focused_workspace  $bg_color ${panel_fbx:-$black} ${window_title:-$yellow}
    active_workspace   ${panel_fbx:-$black} ${window_border_i:-$bg_color} ${window_title:-$light_grey}
    inactive_workspace ${panel_fbx:-$black} ${window_border_i:-$bg_color} ${panel_fbx:-$black}
    urgent_workspace   $bg_color $bg_color ${panel_alert:-$red}
  }
}
EOF
