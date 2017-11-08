FROM debian:stretch

#install subversion
RUN mkdir /home/svn \
	&& cd /home/svn \
	&& apt-get update \
	&& apt-get install -y subversion \
	sudo \
	apache2 \
	libapache2-mod-svn

#create repository 
RUN svnadmin create /home/svn/myproject

#modifite file config apache2
RUN echo '<Location /svn>\n\
             DAV svn\n\
	     SVNParentPath /home/svn\n\
	     AuthType Basic\n\
	     AuthName "Subversion Repository"\n\
	     AuthUserFile /etc/apache2/dav_svn.passwd\n\
	        <LimitExcept GET PROPFIND OPTIONS REPORT>\n\
		    Require valid-user\n\
		</LimitExcept>\n\
	  </Location>' >> /etc/apache2/mods-available/dav_svn.conf

#change owner and group
RUN sudo chown -R www-data:www-data ./

#Add user
RUN echo 'vi-dh:$apr1$e2L.7IB0$ApCSYf2v75wFNr/ynHR07.' >> /etc/apache2/dav_svn.passwd

RUN sudo /etc/init.d/apache2 restart
