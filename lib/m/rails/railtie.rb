# encoding: utf-8
require 'yaml'
require 'ostruct'
# require "singleton"
require "rails"

module Rails #:nodoc:
  module M#:nodoc:
    class Railtie < Rails::Railtie #:nodoc:


      initializer "setup database" do
        config_file = Rails.root.join("config", "m.yml")
        if config_file.file?
          ::M.config = OpenStruct.new YAML::load_file(config_file)
        end
      end

      initializer "verify that m is configured" do
        config.after_initialize do
          begin
            ::M.config
          rescue
            unless Rails.root.join("config", "m.yml").file?
              puts "\nM config not found. Create a config file at: config/m.yml"
              puts "to generate one run: rails generate m:config\n\n"
            end
          end
        end
      end
      
      initializer "run m initializers" do
        initializer_path = File.join(::M.root, 'config', 'initializers')
        Dir.entries(initializer_path).each do |file|
          require File.join(initializer_path, file) if file =~ /\.(rb)$/
        end
      end

      initializer "load admin tabs" do
        ::M.admin_tabs = { :content  => {:name => 'Content', :path => 'admin/nodes', :items => [{:name => 'New Content', :path => '', :items => []}]},
                          :sitebuilding => {:name => 'Site Building', :path => 'admin/nodes', :items => [{:name => 'Site Map', :path => 'admin/nodes', :perm => 'edit sitemap'}]},
                                 :user    => {:name => 'User Management', :path => 'admin/users', :perm => 'manage users', :items => []},
                                 :settings => {:name => 'Settings', :path => 'admin/keys', :perm => 'manage keys', :items => []}
                               }
      end
      
      initializer "set up permissions" do
        ::M.permissions = ::M::Permissions::List.new
      end
      
      initializer "set up resources" do
        require 'm/init_resources'
      end
      
      initializer 'add catch all routes' do |app|
        app.routes_reloader.paths << File.join(File.dirname(__FILE__), 'routes.rb')
      end
      
    end
  end
end
