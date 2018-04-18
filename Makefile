#
BUILDER_ARGS?="--without system_tests --path=${BUNDLE_PATH:-vendor/bundle}"

#
.PHONY: default

#
default: pp

install:
	@echo ">>> bundle install ..."
	bundle install --path vendor/bundle

beaker:
	@echo ">>> Running beaker test ..."
	PUPPET_INSTALL_TYPE=agent BEAKER_debug=true BEAKER_set=ubuntu-1604-x64 BEAKER_destroy=no bundle exec rake beaker
pp:
	@echo ">>> Running rspec test ..."
	PUPPET_GEM_VERSION="~> 5.0" bundle exec rake release_checks

