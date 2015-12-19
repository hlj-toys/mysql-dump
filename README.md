# mysql dump with a schedule

A docker image to dump mysql database on a periodic.

## Usage

There are two methods to run this container.

* **Dump a remote  database:**
 
```shell
  $ docker run -d \
    -e DB_HOST="x.x.x.x" \
    -e DB_USER="myuser" \
    -e DB_PASS="mypassword" \
    -e DATABASE="dbname" \
    -e OPTIONS="mysqldump_options" \
    -e SCHEDULE="dump_schdule" \
    -v /your/backup-folder:/backups betacz/mysql-dump:latest
```
* **Dump a database that's running on a container:**

```shell
  $ docker run -d \
    --link your-mysql-db:db
    -e DB_USER="myuser" \
    -e DB_PASS="mypassword" \
    -e DATABASE="dbname" \
    -e OPTIONS="mysqldump_options" \
    -e SCHEDULE="dump_schdule" \
    -v /your/backup-folder:/backups betacz/mysql-dump:latest
```

## Environments

Some envrionment variable has default value, so you needn't set all of them in most cases.

* `DB_HOST`: Database's hostname or address. If you want to backup a database in container at same host, use `"--link your-db:db"` instead of.
* `DB_USER`: Database's username, default is `"cattle"`.
* `DB_PASS`: Database's password, default is `"cattle"`.
* `DATABASE`: Database's name, default is `"--all-databases"` that means all database. you can use `"db_mame"` to dump only one database or `"--database db1 db2..."` to dump multiple databases.
* `OPTIONS`: Any mysqldump's options you want to use, no default.
* `SCHEDULE`: Explained as shown below. default is `"daily"`.

### Schedule syntax:

* `"hourly"`: 0 minute every hour.
* `"daily"`: 02:00 every day.
* `"weekly"`: 03:00 on Sunday every week.
* `"monthly"`: 05:00 on 1st every month.
* `"0 5 * * 6"`: crontab syntax.

## License
Released under the MIT License. 

Copyright Huang lijun https://github.com/hlj