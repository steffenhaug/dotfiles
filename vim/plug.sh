#! /bin/bash
configfile=${1:-gitclones.txt}

# mini "parser" using awk:
#  - skips empty lines (^$)
#  - skips lines starting with "#" (#.*$)
#  - 
awk '/#.*$/{next} /^$/{next} {x=$1; n=split(x, xs, "/"); print xs[n] " " x}' $configfile |
    while read line; do
        dir=$(echo $line | awk '{print $1}')
        url=$(echo $line | awk '{print $2}')
        absolute_dir=$HOME/.vim/bundle/$dir
        if [ -d $absolute_dir ]; then
            echo "$dir already exists. Updating:"
            cd $absolute_dir
            git pull
        else
            echo "$dir not found. Cloning:"
            git clone $url $absolute_dir
        fi
    done
