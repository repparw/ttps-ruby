# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.

if defined?(Rails::Application::Configuration)
  config = Rails.application.config
  if config.respond_to?(:asset_host)
    config.asset_host = 'your_asset_host'  # Modify as needed
  end
end


# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
