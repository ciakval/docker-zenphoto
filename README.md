# Zenphoto Docker support

This repository contains setup for running [Zenphoto](https://www.zenphoto.org/) in Docker.

## Usage

1. Clone this repository
2. Copy `env.txt.example` to `env.txt` and set secure passwords
3. Run `docker compose up --build` to start the application
4. Open `http://localhost:8000/zenphoto` in your browser

## Configuration

All configuration is done via environment variables in `env.txt` (never committed to git):

| Variable | Description |
|---|---|
| `MARIADB_ROOT_PASSWORD` | MariaDB root password |
| `MARIADB_USER` | Zenphoto database user |
| `MARIADB_PASSWORD` | Zenphoto database password |
| `MARIADB_DATABASE` | Database name |
| `MARIADB_HOST` | Database hostname (use `db` when using compose) |

## Contributing

If you have an idea for improvement, please open an Issue.
If you have or are willing to provide such an improvement, please open a Pull Request.
