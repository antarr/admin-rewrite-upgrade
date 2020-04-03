# Admin

## Setup for Dev

1. Copy over `config/database.yml.example` to `config/database.yml` and edit with your database settings
2. If using Docker, copy `config/database.yml.docker` to `config/database.yml` and run `docker-compose up`
3. run `rails db:setup` to create database(s), including `db:create`, `db:schema:load`, `db:seed`

## Code Quality

1. run `bundle exec rubocop` before committing code to ensure code is consistent

## Testing

1. run `rails test`
2. run `rails test:system` to run system tests
