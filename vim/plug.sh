#! /bin/bash
configfile=${1:-$HOME/dotfiles/vim/plugs.txt}

# mini "parser" using awk:
#  - skips empty lines (^$)
#  - skips lines starting with "#" (#.*$)
#  - get the folder name from the url to check if it already exists
awk '
/#.*$/ {next}
/^$/   {next}
       {x=$1; n=split(x, xs, "/"); print xs[n] " " x}' $configfile |
           while read line; do
               dir=$(echo $line | awk '{print $1}')
               absolute_dir=$HOME/.vim/bundle/$dir

               repository=$(echo $line | awk '{print $2}')
               url=https://github.com/$repository

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
    # use a simmilar awk program to strip the comments,
    # and search for the folder in it.
    if ! awk '
        /#.*$/ {next}
        /^$/   {next}
               {print $1}' $configfile |
                   grep -q "/$line";
    then
        # if the folder is *not* in the config, we remove it.
        echo "$line is in bundle, but not in config. Deleting."
        rm -rf $line
    fi
done
