#!/bin/sh

# Copy filename from http://dev.mysql.com/downloads/repo/apt/
mysql_apt_deb_file=mysql-apt-config_0.3.7-1ubuntu14.04_all.deb

# Change this to your favorite password (do not contain single or double quotes)
# The empty password cannot be used. I tried it but failed.
mysql_root_password=my_password

mysql_root_password_conf_path=./.mysql_root_password.cnf


# Install mysql-apt-config
curl -LO http://repo.mysql.com/${mysql_apt_deb_file}

echo mysql-apt-config mysql-apt-config/select-product          select Apply              | sudo debconf-set-selections
echo mysql-apt-config mysql-apt-config/select-server           select mysql-5.7-dmr      | sudo debconf-set-selections
echo mysql-apt-config mysql-apt-config/select-connector-python select none               | sudo debconf-set-selections
echo mysql-apt-config mysql-apt-config/select-workbench        select none               | sudo debconf-set-selections
echo mysql-apt-config mysql-apt-config/select-utilities        select none               | sudo debconf-set-selections
echo mysql-apt-config mysql-apt-config/select-connector-odbc   select connector-odbc-x.x | sudo debconf-set-selections

export DEBIAN_FRONTEND=noninteractive
sudo -E dpkg -i ${mysql_apt_deb_file}

# Install mysql-community-server
sudo apt-get update
echo mysql-community-server mysql-community-server/re-root-pass password ${mysql_root_password} | sudo debconf-set-selections
echo mysql-community-server mysql-community-server/root-pass    password ${mysql_root_password} | sudo debconf-set-selections
sudo -E apt-get -y install mysql-community-server

# Run mysql_secure_installation
cat > "${mysql_root_password_conf_path}" <<EOF
[client]
password=${mysql_root_password}
EOF

sudo mysql_secure_installation --defaults-extra-file="${mysql_root_password_conf_path}" <<EOF
n
n
y
y
y
y
EOF

rm "${mysql_root_password_conf_path}"

# Output for the above inputs to mysql_secure_installation:
# ---
# Securing the MySQL server deployment.
# 
# 
# VALIDATE PASSWORD PLUGIN can be used to test passwords
# and improve security. It checks the strength of password
# and allows the users to set only those passwords which are
# secure enough. Would you like to setup VALIDATE PASSWORD plugin?
# 
# Press y|Y for Yes, any other key for No: n
# Using existing password for root.
# Change the password for root ? ((Press y|Y for Yes, any other key for No) : n
# 
#  ... skipping.
# By default, a MySQL installation has an anonymous user,
# allowing anyone to log into MySQL without having to have
# a user account created for them. This is intended only for
# testing, and to make the installation go a bit smoother.
# You should remove them before moving into a production
# environment.
# 
# Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
# Success.
# 
# 
# Normally, root should only be allowed to connect from
# 'localhost'. This ensures that someone cannot guess at
# the root password from the network.
# 
# Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
# Success.
# 
# By default, MySQL comes with a database named 'test' that
# anyone can access. This is also intended only for testing,
# and should be removed before moving into a production
# environment.
# 
# 
# Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
#  - Dropping test database...
# Success.
# 
#  - Removing privileges on test database...
# Success.
# 
# Reloading the privilege tables will ensure that all changes
# made so far will take effect immediately.
# 
# Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
# Success.
# 
# All done!
# 

# You may use `--use-default` option instead.
# $ sudo mysql_secure_installation --defaults-extra-file="${mysql_root_password_conf_path}" --use-default
#
# Output for the above inputs to mysql_secure_installation:
# ---
# Securing the MySQL server deployment.
# 
# 
# VALIDATE PASSWORD PLUGIN can be used to test passwords
# and improve security. It checks the strength of password
# and allows the users to set only those passwords which are
# secure enough. Would you like to setup VALIDATE PASSWORD plugin?
# 
# Press y|Y for Yes, any other key for No:  y
# 
# There are three levels of password validation policy:
# 
# LOW    Length >= 8
# MEDIUM Length >= 8, numeric, mixed case, and special characters
# STRONG Length >= 8, numeric, mixed case, special characters and dictionary                  file
# 
# Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:  2
# By default, a MySQL installation has an anonymous user,
# allowing anyone to log into MySQL without having to have
# a user account created for them. This is intended only for
# testing, and to make the installation go a bit smoother.
# You should remove them before moving into a production
# environment.
# 
# Remove anonymous users? (Press y|Y for Yes, any other key for No) :  y
# Success.
# 
# 
# Normally, root should only be allowed to connect from
# 'localhost'. This ensures that someone cannot guess at
# the root password from the network.
# 
# Disallow root login remotely? (Press y|Y for Yes, any other key for No) :  y
# Success.
# 
# By default, MySQL comes with a database named 'test' that
# anyone can access. This is also intended only for testing,
# and should be removed before moving into a production
# environment.
# 
# 
# Remove test database and access to it? (Press y|Y for Yes, any other key for No) :  y
#  - Dropping test database...
# Success.
# 
#  - Removing privileges on test database...
# Success.
# 
# Reloading the privilege tables will ensure that all changes
# made so far will take effect immediately.
# 
# Reload privilege tables now? (Press y|Y for Yes, any other key for No) :  y
# Success.
# 
# All done!

