# -*- encoding: utf-8 -*-
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/starts_ends_with'
require 'active_support/core_ext/string/inflections'

module Qaram
  class FilterModel
    attr_accessor :plugins

    @@unserializable_plugins = [
      {:clasz => Qaram::Plugin::Confidential},
      {:clasz => Qaram::Plugin::Rails}
    ]

    @@serializable_plugins = [
      {:clasz => Qaram::Plugin::View},
      {:clasz => Qaram::Plugin::DateTime},
      {:clasz => Qaram::Plugin::MapReduce},
      {:clasz => Qaram::Plugin::Query}
    ]

    def self.registered_plugins
      @@unserializable_plugins + @@serializable_plugins
    end

    def self.serializable_plugins
      @@serializable_plugins
    end

    def self.clone(filter_model)
      cloned_filter                               = FilterModel.new
      cloned_filter.plugins                       = filter_model.plugins.collect(&:clone)
      return cloned_filter
    end

    def initialize(params = nil, ext_options = {})
      options     = default_options.merge(ext_options)
      @plugins    = []

      unless params.blank?
        if params.is_a?(Hash)
          from_hash(params.symbolize_keys_rec, options[:type])
        elsif params.is_a?(String)
          from_string(params, options[:type])
        end
      end
    end

    def default_options
      {
        :type => :uri
      }
    end

    def from_string(params, type)
      if(type.eql?(:json))
        from_hash(Yajl::Parser.parse(params).symbolize_keys_rec, type)
      else
        raise Exception.new("Sorry, but the combination of params type #{params.class} and provided type #{type} is not yet supported")
      end
    end

    def from_hash(params, type)
      deserialize_plugins(params, type)
    end

    def deserialize_plugins(params, type)
      # if we have a uri represenation, lets iterate over all plugins, and let them
      # pick what the can use from the uri-object (string or hash)
      # we do this, so we don't need to check what param is for what object
      if( type.eql?(:uri))
        self.class.serializable_plugins.each do |plugin|
          begin
            created_plugin = plugin[:clasz].deserialize(params, type)
          rescue Exceptions::RepresentationNotSupported
            next
          end

          if( created_plugin.nil? )
            raise Exception.new("Something during deserialization for Plugin #{plugin[:clasz]} didn't work! Deserialization returned nil'")
          end

          @plugins << created_plugin if created_plugin.present?
        end
      # in this case we know what plugins we have serialized
      # that is, we did add some more option to the serialized object than with uri
      # so we have the luxury to call only those plugins that have actually been serialized
      elsif( type.eql?(:json) || type.eql?(:hash) )
        known_plugin_classes = self.class.registered_plugins.collect{|p|p[:clasz].to_s}
        
        params[:plugins].each do |plugin|
          unless( known_plugin_classes.include?(plugin[:clasz]))
            raise Exception.new("Plugin #{plugin[:clasz]} not registered. I only know about #{known_plugin_classes.join(",")}")
          end

          @plugins << plugin[:clasz].constantize.deserialize(plugin[:data], type)
          
          if( @plugins[-1].nil? )
            raise Exception.new("Something during deseralization for Plugin #{plugin[:clasz]} didn't work! Deserialization returned nil'")
          end
        end
      else
        raise Exception.new("Unknown type #{type}")
      end

      return params
    end

    def clone
      FilterModel.clone(self)
    end

    def serializable_hash()
      {
        :plugins                => plugins.collect{|plugin| {:clasz => plugin.class, :data => plugin.serializable_hash}}
      }
    end

    def digest(clasz = Digest::SHA2)
      clasz.hexdigest(serializable_hash().to_s)
    end

    def json
      Yajl::Encoder.encode(serializable_hash)
    end

    def get_plugins(type)
      plugins.select{|plugin| plugin.class.to_s.eql?(type.to_s)}
    end

    def uri(ext_options = {})
      options = default_uri_options.merge(ext_options)

      u = nil

      plugin_options = {
        :type     => options[:type],
        :encode   => options[:encode]
      }

      # output => u passes the return value along to the next call
      plugins.each do |plugin|
        u_new = plugin.uri(plugin_options.merge({:previous_uri_output => u}))
        u = u_new if u_new.present?
      end

      if u && options[:param_start] && options[:type].eql?(:string)
        u = Qaram::Constants::URI_PARAMS_START + u
      end

      return u
    end

    def default_uri_options
      {
        :type           => :string,
        :encode         => true,
        :param_start    => true
      }
    end

    def eql?(other)
      serializable_hash == other.serializable_hash
    end

    def ==(other)
      eql?(other)
    end

    def log
      puts ("FilterModel: #{self.inspect}")
    end

    # dynamically created methods for accessing the registered plugins
    # it will take the last part of the class name (splitted at ::) and create with this a method
    # that returns the corresponding plugin
    # if no plugin of this type is currently present, it will be created and returned
    # Therefore, if you wish to know if the plugin is "new", you need to call the present? method on the plugin
    registered_plugins.each do |plugin|
      # getters
      p           = plugin[:clasz]
      method_name = p.to_s.split('::')[-1].downcase

      define_method(method_name) do
        method(:get_plugin).call(p)
      end

      # setters
      define_method("#{method_name}=") do |val|
        method(:set_plugin).call(p, val)
      end
    end

    def get_plugin(type)
      # TODO: currently this ist just some badass assumption, that there is ever going to be
      # TODO: only one object from every type
      plugin = get_plugins(type)[0]

      if( plugin.nil? )
        plugin = create_plugin(type, {})
      end
      
      return plugin
    end

    def set_plugin(type, value)
      unless( type.eql?(value.class))
        raise Exception.new("You want to set a plugin with type #{type} to a value with type #{value.class}. Sorry pal, this is a no go!")
      end

      delete_plugin(type)
      @plugins << value

      return value
    end
    
    # TODO: this is currently completly nuts, but I foresee a time when a distinction between
    # TODO: different plugin types is absolutly necessary
    def create_plugin(clasz, options)
      @plugins << clasz.new(options)
      return @plugins[-1]
    end

    def delete_plugin(clasz)
      @plugins.delete_if{|x| x.class.eql?(clasz)}
    end
  end
end
