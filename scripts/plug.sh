#! /bin/bash
configfile=${1:-$HOME/dotfiles/vim/plugs.txt}

# remove comments and empty lines
clean_cfg=$(awk '/#.*$/{next} /^$/{next} {print $1}' $configfile)

for line in $clean_cfg; do
    # get the folder name by splitting on /, and selecting the last word
    dir=$(echo $line | awk -F/ '{print $NF}')
    absolute_dir=$HOME/.vim/bundle/$dir

    url=https://github.com/$line

    if [ -d $absolute_dir ]; then
        echo "$dir already exists. Updating:"
        cd $absolute_dir
        git pull
    else
        echo "$dir not found. Installing:"
        git clone $url $absolute_dir
    fi
done

echo "Done updating! Cleaning up if necessary."

cd $HOME/.vim/bundle

for line in $(ls); do
    # grep the config file for the folder
    if ! grep -q "/$line" <<< $clean_cfg;
    then
        # if the folder is *not* in the config, we remove it.
        echo "$line is in bundle, but not in config. Deleting."
        rm -rf $line
    fi
done
