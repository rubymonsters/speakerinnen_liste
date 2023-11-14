dc=docker-compose -f docker-compose.yml $(1)
dc-run=$(call dc, run --rm web $(1))
dc-run-sp=$(call dc, run --service-ports --rm web $(1))

usage:
	@echo "Available targets:"
	@echo "  * setup                  - Initiates everything (building images, installing gems, creating db and migrating"
	@echo "  * build                  - Build image"
	@echo "  * bundle                 - Install missing gems"
	@echo "  * db-migrate             - Runs the migrations for dev database"
	@echo "  * db-test-migrate        - Runs the migrations for test database"
	@echo "  * seed                   - Seeds dev database with example profiles, and indexes them in Elasticsearch"
	@echo "  * dev                    - Fires a shell inside your container"
	@echo "  * up                     - Runs the development server"
	@echo "  * tear-down              - Removes all the containers and tears down the setup"
	@echo "  * stop                   - Stops the server"
	@echo "  * test                   - Runs all tests"

# With db
setup: build bundle db-create db-migrate db-test-migrate

build:
	$(call dc, build)
bundle:
	$(call dc-run, bundle install)
dev:
	$(call dc-run, bash)
up:
	$(call dc-run-sp)
tear-down:
	$(call dc, down)
stop:
	$(call dc, stop)
console:
	$(call dc-run, bundle exec rails console)
db-create:
	$(call dc-run, bundle exec rake db:create)
db-migrate:
	$(call dc-run, bundle exec rake db:migrate)
db-test-migrate:
	$(call dc-run, bundle exec rake db:migrate RAILS_ENV=test)
seed:
	$(call dc-run, sh -c 'rake db:seed')
test:
	$(call dc-run-sp, sh -c 'bundle exec rspec')
