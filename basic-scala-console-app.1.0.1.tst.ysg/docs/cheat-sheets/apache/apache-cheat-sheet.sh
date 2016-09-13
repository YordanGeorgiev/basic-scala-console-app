# file: docs/cheat-sheets/apache/apache-cheat-sheet.sh

#how-to chech the apache version
apache2ctl -V

#how-to list the installed modules on apache 
apache2ctl -M


# to enable an apache module
a2enmod mime_magic

# do diable an apache module
a2dismod mime_magic


#dirs and files
/var/log/apache2/error.log
/var/log/apache2/access.log


/etc/apache2/sites-available/000-default.conf
/etc/hosts
/etc/apache2/apache2.conf
/etc/apache2/ports.conf
/etc/apache2/sites-available/projects/isg-pub.conf
/etc/apache2/mods-enabled/dir.conf
/etc/apache2/sites-available/projects/project1.conf
/etc/apache2/sites-available/projects/you-doc.conf
/etc/apache2/sites-available/projects/isg-pub-startup.pl
/etc/apache2/sites-available/projects/mod_perl_startup.pl
/etc/apache2/envvars
/etc/apache2/conf-available/serve-cgi-bin.conf
/etc/apache2/mods-available/apreq2.load
/etc/apache2/mods-available/mpm_event.load
/etc/apache2/mods-available/mpm_event.conf
/etc/apache2/mods-available/mime.load
/etc/apache2/mods-available/mime_magic.conf
/etc/apache2/mods-available/perl.load


/var/log/apache2/
/var/log/apache2/isg-pub.access.log
/var/log/apache2/isg-pub.error.log
# important configuration files
/etc/apache2/apache2.conf
/etc/apache2/sites-available/projects/core-dw.conf
/etc/apache2/sites-available/projects/geo-fin.conf
/etc/apache2/sites-available/projects/core-dw-startup.pl
/etc/apache2/sites-available/projects/isg-pub-startup.pl
/etc/apache2/sites-available/projects/mod_perl_startup.pl
/etc/apache2/sites-available/projects/ysg.conf



#eof file:docs/cheat-sheets/apache/apache-cheat-sheet.sh
