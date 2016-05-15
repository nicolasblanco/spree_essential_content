module SpreeEssentialContent
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_essential_content'

    #initializer "spree.essential_content.preferences", :before => :load_config_initializers do |app|
    #  Spree::EssentialContent::Config = Spree::BlogConfiguration.new
    #end

    initializer "spree.essential_content.paperclip", :before => :load_config_initializers do |app|
      Paperclip::Attachment.default_options.merge!(
        :style => :medium
      )
    end

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob File.expand_path("../../../app/overrides/**/*.rb", __FILE__) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    # sets the manifests / assets to be precompiled, even when initialize_on_precompile is false
    initializer "spree.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        spree/backend/post_product/new.js
        spree/backend/post_product/index.js
      ]
    end
  end
end
