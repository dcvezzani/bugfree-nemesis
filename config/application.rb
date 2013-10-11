require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

require 'active_model'

module Clf004
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/spec/support) if Rails.env.development?
    config.autoload_paths += %W(#{config.root}/app/reports)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Additional paths where assets may be looked for
    config.assets.paths %W(#{config.root}/bootstrap #{config.root}/bootstrap_wizard #{config.root}/jquery.ui.theme.lightness/css/ui-lightness #{config.root}/jquery.timepicker/css)
    # #{config.root}/backbone

    initializer :after_append_asset_paths, 
                :group => :all, 
                :after => :append_assets_path do
       #config.assets.paths.unshift Rails.root.join(config.root, "app", "assets", "backbone").to_s
       config.assets.paths.unshift Rails.root.join(config.root, "app", "assets", "bootstrap", "css").to_s
       config.assets.paths.unshift Rails.root.join(config.root, "app", "assets", "bootstrap_wizard").to_s
       config.assets.paths.unshift Rails.root.join(config.root, "app", "assets", "jquery.ui.theme.lightness", "css", "ui-lightness").to_s
       config.assets.paths.unshift Rails.root.join(config.root, "app", "assets", "jquery.timepicker", "css").to_s
    end

    config.generators do |g|
      g.test_framework :rspec, :fixtures => false, :views => false, :view_specs => false, :requests => false
    end

    # (Devise installation instructions) If you are deploying Rails 3.1 on Heroku, you may want to set:
    config.assets.initialize_on_precompile = false

    #config.assets.precompile += ['application-backbone.js']
  end
end
