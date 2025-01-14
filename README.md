# ZenPhoto CMS Docker support

This repository contains setup for running ZenPhoto (https://www.zenphoto.org/) in Docker.

## Usage

1. Clone this repository
2. (Optional) Change the unsafe passwords in _env.txt_
3. Run `docker compose up --build` to start the application
4. Open URL "http://localhost:8000/zenphoto" in your browser to access ZenPhoto

## Caveats

The passwords in _env.txt_ are weak and public, change them before production use!!

## Contributing

If you have an idea for improvement, please open an Issue.
If you have or are willing to provide such an improvement, please open a Pull Request.
