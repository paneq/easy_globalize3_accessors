require 'globalize'

module EasyGlobalize3Accessors
  attr_reader :globalize_locales
  attr_reader :globalize_attribute_names

  def globalize_accessors(options = {})
    options.reverse_merge!(:locales => I18n.available_locales, :attributes => translated_attribute_names)
    @globalize_locales = options[:locales]
    @globalize_attribute_names = []

    each_attribute_and_locale(options) do |attr_name, locale|
      define_accessors(attr_name, locale)
    end
  end


  private


  def define_accessors(attr_name, locale)
    define_getter(attr_name, locale)
    define_setter(attr_name, locale)
  end


  def define_getter(attr_name, locale)
    define_method :"#{attr_name}_#{locale.to_s.underscore}" do
      read_attribute(attr_name, :locale => locale)
    end
  end

  def define_setter(attr_name, locale)
    localized_attr_name = "#{attr_name}_#{locale.to_s.underscore}"

    define_method :"#{localized_attr_name}=" do |value|
      write_attribute(attr_name, value, :locale => locale)
    end
    if respond_to?(:accessible_attributes) && accessible_attributes.include?(attr_name)
      attr_accessible :"#{localized_attr_name}"
    end
    @globalize_attribute_names << localized_attr_name.to_sym
  end

  def each_attribute_and_locale(options)
    options[:attributes].each do |attr_name|
      options[:locales].each do |locale|
        yield attr_name, locale
      end
    end
  end

end

ActiveRecord::Base.extend EasyGlobalize3Accessors
