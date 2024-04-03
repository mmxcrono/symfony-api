# symfony-api

Set up symfony with docker

## Install Symfony CLI

For Mac

```sh
brew install symfony-cli/tap/symfony-cli
```

For Windows

Open a powershell window (not as admininstrator)

```sh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

In your normal terminal like bash

```sh
scoop install symfony-cli
```

## Make commands

`make build`
  - Builds local with docker build
  - Enables XDebug in container

`make run`
  - Runs the local docker build into container name symfony-api
  - Mounts `src`

## Setup steps history

- Install `php` through `homebrew`
- Install `xdebug` through `pecl`
- Install `symfony` through `homebrew`
- Install Docker or Docker Desktop
- Run `symfony new src`
- Create `docker` folder
- Create `Dockerfile`
- Create `nginx` folder with `default.conf`
- Create `entrypoint.sh`
- Create `.env.example`
- Create `Makefile`