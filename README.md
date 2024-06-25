([简体中文](./README_zh.md)|[English])

# MySQL Dump with a Schedule

A Docker image to periodically dump a MySQL database.

## Usage

There are two methods to run this container:

### Examples

1. **Dump a remote database:**

```shell
docker run -d \
  -e DUMP_DEBUG="true" \
  -e MYSQL_HOST="x.x.x.x" \
  -e MYSQL_PORT="xxx"  \
  -e MYSQL_USER="myuser" \
  -e MYSQL_PASSWORD="mypassword" \
  -e MYSQL_DATABASE="dbname" \
  -e OPTIONS="<mysqldump_options>" \
  -e SCHEDULE="dump_schedule" \
  -e RESERVES="dump_file_reserve_number" \
  -v /your/backup-folder:/backups betacz/mysql-dump:latest
```

2. **Dump a database running in a container:**

```shell
docker run -d \
  --link your-mysql-db:db \
  -e DUMP_DEBUG="true" \
  -e MYSQL_USER="myuser" \
  -e MYSQL_PORT="xxx"  \
  -e MYSQL_PASSWORD="mypassword" \
  -e MYSQL_DATABASE="dbname" \
  -e OPTIONS="mysqldump_options" \
  -e SCHEDULE="dump_schedule" \
  -e RESERVES="dump_file_reserve_number" \
  -v /your/backup-folder:/backups betacz/mysql-dump:latest
```

The dumped file will be named `"db_backup_<timestamp>.gz"`.

### Additional Usage

To perform an immediate dump:

```shell
docker run [options] betacz/mysql-dump:latest dump
```

The `[options]` are the same as above.

## Environment Variables

Some environment variables have default values, so you may not need to set all of them.

- `MYSQL_HOST`: Database's hostname or address. If backing up a database in a container on the same host, use `"--link your-db:db"`.
- `MYSQL_PORT`: Default is 3306.
- `MYSQL_USER`: Database's username, default is `"root"`.
- `MYSQL_PASSWORD`: Database's password. If not set, use `MYSQL_PASSWORD_FILE`.
- `MYSQL_PASSWORD_FILE`: Docker swarm secret name.
- `MYSQL_DATABASE`: Database's name, default is `"--all-databases"` to dump all databases. You can use `"dbname"` to dump a specific database or `"--databases db1 db2..."` to dump multiple databases.
- `OPTIONS`: Any `mysqldump` options you want to use, no default.
- `SCHEDULE`: Schedule for the dumps, default is `"daily"`.
- `RESERVES`: Number of dump files to retain, default is `7`.
- `DUMP_DEBUG`: If set to `"true"`, debug info will be shown. Default is `"false"`.
- `TZ`: Time zone code, like `"Asia/Shanghai"`, default is `"UTC"`.

### Schedule Syntax

- `"hourly"`: At the 0th minute of every hour.
- `"daily"`: At 02:00 every day.
- `"weekly"`: At 03:00 every Sunday.
- `"monthly"`: At 05:00 on the 1st of every month.
- `"0 5 * * 6"`: Crontab syntax for custom scheduling.

## Encryption

If your dump contains sensitive data, you can encrypt it using the `ENCRYPT_KEY` environment variable:

```shell
docker run -e ENCRYPT_KEY=your-key [other-options] betacz/mysql-dump:latest
```

The dumped file will be encrypted with `AES-256-CBC` and have a `'.aes'` extension.

### Decrypting Files

To decrypt a file:

```shell
docker run -e ENCRYPT_KEY=your-key \
  -v /your/backup-folder:/backups \
  -v /your/output:/output \
  betacz/mysql-dump:latest \
  decrypt db_backup_<timestamp>.gz.aes /output
```

The `decrypt` command accepts one or two arguments: `decrypt <source file> [dest-folder]`. If `dest-folder` is not specified, the decrypted file will be saved in the same folder as the source file.

## License

Released under the MIT License. 

Copyright Huang Lijun https://github.com/hlj