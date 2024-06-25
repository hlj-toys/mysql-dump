(简体中文|[English](./README.md))

# 定期 Dump MySQL 数据库

一个用于定期备份 MySQL 数据库的 Docker 镜像。

## 使用方法

有两种方法运行此容器：

### 示例

1. **备份远程数据库：**

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

2. **备份运行在容器中的数据库：**

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

备份文件将被命名为 `"db_backup_<timestamp>.gz"`。

### 额外用法

立即执行备份：

```shell
docker run [options] betacz/mysql-dump:latest dump
```

上述命令中的 `[options]` 与之前示例中的相同。

## 环境变量

有些环境变量有默认值，因此大多数情况下您不需要设置所有变量。

- `MYSQL_HOST`: 数据库的主机名或地址。如果备份同一主机上的容器内的数据库，请使用 `"--link your-db:db"`。
- `MYSQL_PORT`: 默认是 3306。
- `MYSQL_USER`: 数据库用户名，默认是 `"root"`。
- `MYSQL_PASSWORD`: 数据库密码。如果未设置，请使用 `MYSQL_PASSWORD_FILE`。
- `MYSQL_PASSWORD_FILE`: Docker Swarm 密码名称。
- `MYSQL_DATABASE`: 数据库名称，默认是 `"--all-databases"`，表示备份所有数据库。您可以使用 `"dbname"` 备份特定数据库或 `"--databases db1 db2..."` 备份多个数据库。
- `OPTIONS`: 任何 `mysqldump` 选项，无默认值。
- `SCHEDULE`: 备份计划，默认是 `"daily"`。
- `RESERVES`: 保留的备份文件数量，默认是 `7`。
- `DUMP_DEBUG`: 如果设置为 `"true"`，则显示调试信息。默认是 `"false"`。
- `TZ`: 时区代码，例如 `"Asia/Shanghai"`，默认是 `"UTC"`。

### 计划语法

- `"hourly"`: 每小时的第0分钟。
- `"daily"`: 每天的 02:00。
- `"weekly"`: 每周日的 03:00。
- `"monthly"`: 每月1日的 05:00。
- `"0 5 * * 6"`: 自定义 crontab 语法。

## 加密

如果备份中包含敏感数据，可以使用 `ENCRYPT_KEY` 环境变量进行加密：

```shell
docker run -e ENCRYPT_KEY=your-key [other-options] betacz/mysql-dump:latest
```

备份文件将使用 `AES-256-CBC` 加密，并带有 `'.aes'` 扩展名。

### 解密文件

解密文件的方法如下：

```shell
docker run -e ENCRYPT_KEY=your-key \
  -v /your/backup-folder:/backups \
  -v /your/output:/output \
  betacz/mysql-dump:latest \
  decrypt db_backup_<timestamp>.gz.aes /output
```

`decrypt` 命令接受一个或两个参数：`decrypt <source file> [dest-folder]`。如果未指定 `dest-folder`，解密文件将保存在源文件相同的文件夹中。

## 许可

根据 MIT 许可发布。

版权所有 Huang Lijun  https://github.com/hlj