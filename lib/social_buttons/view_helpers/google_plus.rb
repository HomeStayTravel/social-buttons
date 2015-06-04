module SocialButtons
  module GooglePlus
    include SocialButtons::Assistant

    autoload :Help, "social_buttons/view_helpers/google_plus/help"

    CLASS = "g-plusone"

    # https://www.google.com/intl/en/webmasters/+1/button/index.html

    def google_plus_button *args
      options = args.extract_options!
      klazz = SocialButtons::GooglePlus
      return klazz.script(options) if args.first == :script

      locale = options.delete(:locale) || options.delete(:lang)

      params = klazz.options_to_data_params(klazz.default_options.merge(options))
      params.merge!(class: CLASS)

      html = "".html_safe
      html << content_tag(:div, nil, params)
      html << klazz::Scripter.new(self).script(locale)
      html
    end

    class << self
      include Help

      def default_options
        @default_options ||= {
          annotations:    "inline"
        }
      end
    end

    class Scripter < SocialButtons::Scripter

      def script lang = nil
        return empty_content if widgetized? :google_plus
        widgetized! :google_plus
        %Q{<script type="text/javascript">
          #{language lang}
    (function(window, document, undefined) {
      window.addEventListener('load', function(){
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://apis.google.com/js/plusone.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
      }, false);
    })(window, document);
        </script>}.html_safe
      end

      def language lang = nil
        "window.___gcfg = {lang: '#{lang}'};" if lang
      end
    end

  end
end
