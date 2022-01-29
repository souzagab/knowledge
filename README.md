<h1> Knowledge </h1>

Knowledge is learning management system that allows you to manage courses for users.

## Architecture

**Knowledge** is an api made using `Rails`. Using `devise` to manage authentication, `CanCanCan` for managing user _roles_. `ActiveStorage` and `Amazon's S3` for managing files via direct upload.

You can check more about this application on [**wiki**](https://github.com/souzagab/knowledge/wiki), there you will find about the resources, relations, dependencies and documentation for the available routes.

## Development

### Deppendencies

- Ruby `3.1.0`
- Rails `7.0.1`
- PostgreSQL `14.0`

#### Docker

If you prefer to use it, the application is configured for container development via `docker` and `docker-compose`.

I prepare a snippet in to facilitate the setup, so just run:

```sh

     bin/docker/build

```

And that will pull the necessary images, and configure the application for you.
After that just run:

```sh

  docker-compose up

```

And you are ready to go =)
