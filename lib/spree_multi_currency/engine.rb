module SpreeMultiCurrency
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_multi_currency'
    config.autoload_paths += %W[#{config.root}/lib]

    require 'spree/core/currency_helpers'

    # initializer "spree.register.multi_currency_configuration", before: :load_config_initializers do |_app|
    # end

    # initializer "spree.multi_currency_configuration.register.currency_configuration", :before => :load_config_initializers do |app|
    #   Spree::MultiCurrencyConfiguration::Config = Spree::MultiCurrencyConfiguration.new
    # end

    def self.activate
      ['../../app/**/*_decorator*.rb', '../../lib/**/*_decorator*.rb'].each do |path|
        Dir.glob(File.join(File.dirname(__FILE__), path)) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end
      ApplicationController.send :include, Spree::CurrencyHelpers
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
