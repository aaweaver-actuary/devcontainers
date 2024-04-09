install_dotfiles:
	git clone http://github.com/aaweaver-actuary/dotfiles
	chmod +x dotfiles/install_dotfiles
	mv dotfiles/install_dotfiles /usr/bin/install_dotfiles
	rm -rf dotfiles