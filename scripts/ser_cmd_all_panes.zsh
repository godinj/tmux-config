#!/bin/zsh

sess=$(tmux display-message -p '#S')
win=$(tmux display-message -p '#I')
lock="$sess-$win"

n_pane=$(tmux list-panes | wc -l | xargs)

hold="tmux wait-for -L $lock"
unlock="tmux wait-for -U $lock"

cmd="eval \"$*\""

n_cmd="$cmd; $unlock"

eval $unlock
eval $cmd
eval $hold
for ((i = 1; i < $n_pane; i++)); do 
  pane="$sess.$i";
  tmux send-keys -t $pane $n_cmd Enter\;
  eval $hold
done
