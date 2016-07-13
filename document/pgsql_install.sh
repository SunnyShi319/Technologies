mkdir ~/tmp
pushd ~/tmp

wget http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/postgresql94-libs-9.4.7-1PGDG.rhel7.x86_64.rpm
wget http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/postgresql94-9.4.7-1PGDG.rhel7.x86_64.rpm
wget http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/postgresql94-contrib-9.4.7-1PGDG.rhel7.x86_64.rpm
wget http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/postgresql94-server-9.4.7-1PGDG.rhel7.x86_64.rpm

yum install -y postgresql94-libs-9.4.7-1PGDG.rhel7.x86_64.rpm
yum install -y postgresql94-9.4.7-1PGDG.rhel7.x86_64.rpm
yum install -y postgresql94-contrib-9.4.7-1PGDG.rhel7.x86_64.rpm
yum install -y postgresql94-server-9.4.7-1PGDG.rhel7.x86_64.rpm

rm -f postgresql94-libs-9.4.7-1PGDG.rhel7.x86_64.rpm
rm -f postgresql94-9.4.7-1PGDG.rhel7.x86_64.rpm
rm -f postgresql94-contrib-9.4.7-1PGDG.rhel7.x86_64.rpm
rm -f postgresql94-server-9.4.7-1PGDG.rhel7.x86_64.rpm

popd

/usr/pgsql-9.4/bin/postgresql94-setup initdb
systemctl enable postgresql-9.4.service
systemctl start postgresql-9.4.service