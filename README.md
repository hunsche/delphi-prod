# Docker

This project requires the tools:
  
  - Docker Machine
  - Docker Compose
  - Docker

### Installation

Use git bash to configuration tools.

Install Docker Machine.

```sh
$ mkdir -p "$HOME/bin"
$ curl -L "https://github.com/docker/machine/releases/download/v0.14.0//docker-machine-Windows-x86_64.exe" > "$HOME/bin/docker-machine.exe"
$ chmod +x "$HOME/bin/docker-machine.exe"
```

Create and configure default machine.

```sh
$ docker-machine create default
$ eval $(docker-machine env default)
```

Install Docker Compose

```sh
$ curl -L "https://github.com/docker/compose/releases/download/1.22.0-rc1/docker-compose-Windows-x86_64.exe" > "$HOME/bin/docker-compose.exe"
$ chmod +x "$HOME/bin/docker-compose.exe"
```

Install Docker

```sh
$ mkdir -p "$HOME/tmp"
$ curl -L "https://download.docker.com/win/static/stable/x86_64/docker-17.09.0-ce.zip" > "$HOME/tmp/docker.zip"
$ unzip "$HOME/tmp/docker.zip" -d "$HOME/tmp/"
$ mv "$HOME/tmp/docker/docker.exe" "$HOME/bin/docker.exe"
$ rm -rf "$HOME/tmp/docker" "$HOME/tmp/docker.zip"
```

### Get start

Use git bash to start service.

### RAD Server 

Create docker-compose.yml of RAD Server with connection in database. 

```yml
version: '2.1'

services:
  service:
    image: hunsche/delphi-prod
    environment: 
      - RAD_SERVER_DB_PATH=ip_interbase/port_interbase:C:/path_database/emsserver.ib
    links:
      - postgres:postgres
    ports:
      - '80:80'
    command: waitforit -address=tcp://ip_interbase:port_interbase -address=tcp://postgres:5432 -timeout=10 -- start

  postgres:
    image: postgres:10.4
    ports:
      - "5432:5432"
```

### Build Dockerfile 

```yml
FROM hunsche/delphi-prod
COPY dist /dist
RUN cp -f $(find /dist -iname "*.so") /usr/lib/ems 2> /dev/null || true
```

### Environment

  - RAD_SERVER_DB_INSTANCENAME: Instance name of interbase to RAD Server.
  - RAD_SERVER_DB_PATH: PATH of database interbase.
  - RAD_SERVER_DB_USERNAME: Username of database interbase.
  - RAD_SERVER_DB_PASSWORD: Password of database interbase.
  - RAD_SERVER_MASTER_SECRET: Master secret of RAD Server.
  - RAD_SERVER_APP_SECRET: App secret of RAD Server.
  - RAD_SERVER_APPLICATION_ID: Application ID of RAD Server.
  - RAD_SERVER_CONSOLE_USER: User of RAD Server Console.
  - RAD_SERVER_CONSOLE_PASS: Password of RAD Server Console.
  - RAD_SERVER_CONSOLE_PORT: RAD Server Console Port.
  - RAD_SERVER_RESOURCES_FILES: Resource files of RAD Server Console.
  - DB_DRIVER: driver database using to migrations.
  - DB_HOST: Host database using to migrations.
  - DB_PORT: Port database using to migrations.
  - DB_DATABASE: Name database using to migrations.
  - DB_USER: User database using to migrations.
  - DB_PASSWORD: Password database using to migrations.
  - DB_MIGRATE_ENABLE: Enabled migrate to database.
  - DB_MIGRATE_PATH: Migrations locale path to migrations in database.