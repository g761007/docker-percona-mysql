FROM phusion/baseimage:0.9.12
MAINTAINER Daniel <a761007@gmail.com>

# Install packages
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
RUN echo 'deb http://repo.percona.com/apt trusty main' > /etc/apt/sources.list.d/percona.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install percona-server-server-5.6
RUN apt-get install pwgen

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL configuration
ADD ./files/my.cnf /etc/mysql/conf.d/my.cnf
ADD ./files/mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# Add MySQL scripts
ADD ./files/create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD ./files/import_sql.sh /import_sql.sh
ADD ./files/run.sh /run.sh
RUN chmod 755 /*.sh

# Exposed ENV
ENV MYSQL_USER admin
ENV MYSQL_PASS **Random**

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306
CMD ["./run.sh"]