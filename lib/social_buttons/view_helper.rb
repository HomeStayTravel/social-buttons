module SocialButtons
  SocialButtons.all.flatten.each do |name|
    autoload name.to_s.camelize.to_sym, "social_buttons/view_helpers/#{name}"
  end

  module ViewHelper
    extend ActiveSupport::Concern

    included do
      # Include all Social Buttons into ViewHelper to be made available
      # to be included into a View as one module (see engine)
      SocialButtons.names.each do |name|
        self.send :include, "SocialButtons::#{name.to_s.camelize}".constantize

        attr_accessor :"#{name}_widgetized"
        alias_method  :"#{name}_widgetized?", :"#{name}_widgetized"
      end
    end

    def widgetized! name
      meth = "#{name}_widgetized="
      self.send(meth, name) if respond_to? meth
    end

    def widgetized? name
      meth = "#{name}_widgetized?"
      self.send(meth) if respond_to? meth
    end
  end
end
