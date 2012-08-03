require 'globalize3'

module EasyGlobalize3Accessors

  def globalize_accessors(options = {})
    options.reverse_merge!(:locales => I18n.available_locales, :attributes => translated_attribute_names)

    each_attribute_and_locale(options) do |attr_name, locale|
      define_accessors(attr_name, locale)
      define_accessible(attr_name, locale)
    end
  end


  private
    

  def define_accessors(attr_name, locale)
    define_getter(attr_name, locale)
    define_setter(attr_name, locale)
  end
  
  def define_accessible(attr_name, locale)
      attr_accessible("#{attr_name}_#{locale}")
    end


  def define_getter(attr_name, locale)
    define_method :"#{attr_name}_#{locale}" do
      read_attribute(attr_name, :locale => locale)
    end
  end

  def define_setter(attr_name, locale)
    define_method :"#{attr_name}_#{locale}=" do |value|
      write_attribute(attr_name, value, :locale => locale)
    end
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
