require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Totems
  class Application < Rails::Application
    config.action_cable.mount_path = '/cable'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_view.sanitized_allowed_tags = ['b']
    config.autoload_paths << Rails.root.join('lib')
  end
end
