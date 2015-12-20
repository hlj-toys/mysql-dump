# mysql dump with a schedule

A docker image to dump mysql database on a periodic.

## Usage

There are two methods to run this container. 

**Examples**

* **Dump a remote  database:**
 
```shell
  $ docker run -d \
    -e DUMP_DEBUG="true" \
    -e DB_HOST="x.x.x.x" \
    -e DB_USER="myuser" \
    -e DB_PASS="mypassword" \
    -e DATABASE="dbname" \
    -e OPTIONS="<mysqldump_options>" \
    -e SCHEDULE="dump_schdule" \
    -e RESERVES="dump_file_reserve_number" \
    -v /your/backup-folder:/backups betacz/mysql-dump:latest
```
* **Dump a database that's running on a container:**

```shell
  $ docker run -d \
    --link your-mysql-db:db
    -e DUMP_DEBUG="true" \
    -e DB_USER="myuser" \
    -e DB_PASS="mypassword" \
    -e DATABASE="dbname" \
    -e OPTIONS="mysqldump_options" \
    -e SCHEDULE="dump_schdule" \
    -e RESERVES="dump_file_reserve_number" \
    -v /your/backup-folder:/backups betacz/mysql-dump:latest
``` 

The dumped file will be named as `"db_backup_<timestamp>.gz"`.

**Additional,** you can do dump immediately like this:

```shell
  $ docker run [options] betacz/mysql-dump:latest dump
```

The `[options]` is as same as above. 


## Environments

Some envrionment variable has default value, so you needn't set all of them in most cases.

* `DB_HOST`: Database's hostname or address. If you want to backup a database in container at same host, use `"--link your-db:db"` instead of.
* `DB_USER`: Database's username, default is `"cattle"`.
* `DB_PASS`: Database's password, default is `"cattle"`.
* `DATABASE`: Database's name, default is `"--all-databases"` that means all database. you can use `"db_mame"` to dump only one database or `"--databases db1 db2..."` to dump multiple databases.
* `OPTIONS`: Any mysqldump's options you want to use, no default.
* `SCHEDULE`: Explained as shown below. default is `"daily"`.
* `RESERVES`: Dump file reserve numbers. default is `7`.
* `DUMP_DEBUG`: If set `"true"` then show debug info. default is `"false"`.

### Schedule syntax:

* `"hourly"`: 0 minute every hour.
* `"daily"`: 02:00 every day.
* `"weekly"`: 03:00 on Sunday every week.
* `"monthly"`: 05:00 on 1st every month.
* `"0 5 * * 6"`: crontab syntax.

## Encrypt

If you dump a database that's include secret data, maybe you want to encrypt it.

There is a envrionment variable `"ENCRYPT_KEY"` can do this as shown below:

```shell
   $ docker run -e ENCRYPT_KEY=your-key [other-options] betacz/mysql-dump:latest
```

The dumped file will be encrypted with `AES-256-CBC` and named with a `'.aes'` extension.

## License
Released under the MIT License. 

Copyright Huang lijun https://github.com/hlj