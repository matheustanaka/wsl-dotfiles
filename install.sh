#!/bin/bash

echo "Start the dotfiles installation"
echo

install_zsh() {	
	if command -v zsh > /dev/null 2>&1;
	then
		echo "zsh is already installed"
		echo $SHELL
	else
		echo "Installing ZSH ..."
		sudo apt update
		sudo apt install zsh

		echo "Installing oh-my-zsh"
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

		echo "Make zsh the default shell"
		chsh -s $(which zsh)
		echo "You should log out and log back to verify it"

	fi
}

install_starship() {
	echo "Installing starship"
	curl -sS https://starship.rs/install.sh | sh

	echo "Installing zsh synxtax highlight"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

	echo "Installing zsh autosuggestion"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	echo "Installing asdf"
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

	echo
	echo "Copy zsh config"
	cp -i $HOME/.dotfiles/wsl-dotfiles/zsh/.zshrc $HOME

	echo
	echo "Copying starship config file"
	cp -i $HOME/.dotfiles/wsl-dotfiles/starship/starship.toml $HOME/.config/

	echo "log out and log back to restart the config"
}

install_tmux (){
	echo "Installing TMUX ..." 
	git clone https://github.com/tmux/tmux.git
	
	cd $HOME/tmux
	sh autogen.sh
	./configure
	make && sudo make install

	echo 
	echo "Copying the TMUX config file"
	cp -i $HOME/.dotfiles/wsl-dotfiles/tmux/.tmux.conf $HOME

	echo "Initializing tmux"
	tmux

	echo "Download is completed"
}

install_neovim () {
	echo "Installing Neovim Editor"

	echo
	echo "Installing dependencies"
	sudo apt-get install ninja-build gettext cmake unzip curl

	echo
	echo "Cloning the repository"
	cd $HOME
	git clone https://github.com/neovim/neovim.git
	cd neovim
	git checkout release-0.9
	make CMAKE_BUILD_TYPE=Release
	sudo make install

	echo "Copying neovim config"
	cp -r $HOME/.dotfiles/wsl-dotfiles/nvim/ $HOME/.config/

}

echo "Don't forget to run source .zshrc to load zsh configuration"

install_zsh
install_starship
install_tmux
install_neovim
