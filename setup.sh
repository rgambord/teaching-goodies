#!/usr/bin/bash

# This script installs the most recent version of vim, along
# with all the settings and plugins used by the instructor

mkdir -p "$HOME/.local/bin"

# Install vim
pushd vim/src
./configure --prefix="$HOME/.local"
make -j 64
make install -j64 
popd


# add local paths to their respective environment variables
if [ -z "$LOCAL_PATHS_DEFINED" ]
then
    cat > "$HOME/.profile" << __HEREDOC__
# Add .local to appropriate path env variables
export LOCAL_PATHS_DEFINED="yes"
export PATH="$HOME/.local/sbin:$HOME/.local/bin/:$PATH"
export CPATH="$HOME/.local/include:$CPATH"
export LD_LIBRARY_PATH="$HOME/.local/lib64:$HOME/.local/lib32:$HOME/.local/lib:$LD_LIBRARY_PATH"
export MANPATH="$HOME/.local/share/man:$MANPATH"
__HEREDOC__

    echo -e ". \"$HOME/.profile\"" >> "$HOME/.bash_profile"

fi

cp --backup=existing vimrc.example "$HOME/.vimrc"
cp --backup=existing bashrc.example "$HOME/.bashrc"
cp --backup=existing inputrc.example "$HOME/.inputrc"

# install vundle
mkdir -p "$HOME/.local/share/vim/bundle"
cp -rf Vundle.vim "$HOME/.local/share/vim/bundle/"
"$HOME/.local/bin/vim" -c 'PluginInstall' -c qa

echo "All done! Make sure to log out and log back in!" 
