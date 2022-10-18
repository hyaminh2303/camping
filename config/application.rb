require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GCamp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Asia/Tokyo"
    # config.eager_load_paths << Rails.root.join("extras")

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ja
    I18n.available_locales = [:ja, :en, :zh, :ko]
    # In order to enable overriding the error message's format at the model level and at the attribute level.
    config.active_model.i18n_customize_full_message = true
  end
end
