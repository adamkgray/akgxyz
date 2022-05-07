build:
	jb clean book && jb build book

deploy:
	rsync -alPvz -e "ssh -i ${HOME}/.ssh/akgxyz-server" ./book/_build/html root@akg.xyz:/usr/share/nginx/
