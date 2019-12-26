    # List of all systemctl commands ran during the initial install script

	### Mysql
	- sudo systemctl start mysql
    - sudo systemctl enable mysql

	### Nginx
	- sudo systemctl start nginx.service
    - sudo systemctl enable nginx.service
    - sudo systemctl start cron.service
    - sudo systemctl enable cron.service

	### PHP
	- sudo systemctl start php7.0-fpm.service

	## To reload 
	- sudo systemctl reload php7.0-fpm.service
    - sudo systemctl restart nginx.service
	