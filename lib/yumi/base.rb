# app/yumi/base.rb
require_relative 'class_methods'

module Yumi
  class Base
    extend Yumi::ClassMethods

    attr_accessor :override_type, :url, :resource, :type, :links, :attributes, :relationships,
                  :presenter_module, :prefix, :relationships, :fields

    def initialize(url, resource, presenter_module = nil, prefix = nil, fields = nil)
      @url = url
      @resource = resource
      @fields = fields
      @presenter_module = presenter_module
      @prefix = prefix
      set_instance_variables
    end

    def as_relationship
      {
        data: data,
        links: {
          self: "#{@url}/#{@prefix}relationships/#{@type.pluralize}"
        }
      }
    end

    def as_included
      {
        type: @type.pluralize,
        id: @resource.id.to_s,
        attributes: Yumi::Presenters::Attributes.new(self).to_json_api,
        links: Yumi::Presenters::Links.new(self).to_json_api
      }
    end

    protected

    def object
      @resource
    end

    private

    def data
      if @resource.respond_to?(:each)
        @resource.map do |c|
          type = @override_type ? resource_type(c) : @type.pluralize
          { type: type, id: c.id.to_s }
        end
      else
        {
          type: @override_type ? resource_type(@resource) : @type.pluralize,
          id: @resource.id.to_s
        }
      end
    end

    # Assigns the class variables to the instance
    def set_instance_variables
      @override_type = respond_to?(:resource_type)
      instance_variable_set('@type', self.class.send('_type') || 'base')

      [:relationships, :links, :attributes].each do |v|
        instance_variable_set("@#{v}", self.class.send("_#{v}") || [])
      end
    end
  end
end
