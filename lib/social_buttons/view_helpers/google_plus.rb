module SocialButtons
  module GooglePlus
    include SocialButtons::Assistant

    autoload :Help, "social_buttons/view_helpers/google_plus/help"

    CLASS = "g-plusone"

    # https://www.google.com/intl/en/webmasters/+1/button/index.html

    # Async script mode:
    #   To only output script
    #   = google_button :script, locale: 'es'

    #   To NOT output script
    #   = google_button :locale => 'es', script: false
    def google_plus_button *args
      options = args.extract_options!
      clazz = SocialButtons::GooglePlus
      return clazz.script(options) if args.first == :script

      use_script = options.delete :script
      locale = options.delete(:locale) || options.delete(:lang)

      params = clazz.options_to_data_params(clazz.default_options.merge(options))
      params.merge!(class: CLASS)

      scripter_class = use_script == :async ? clazz::AsyncScripter : clazz::Scripter

      html = "".html_safe
      html << content_tag(:div, nil, params)
      html << scripter_class.new(self).script(locale) if use_script
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
        %q{<script type="text/javascript">
          #{language lang}
    (function() {
      var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
      po.src = 'https://apis.google.com/js/plusone.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    })();
        </script>}.html_safe
      end

      def language lang = nil
        "window.___gcfg = {lang: '#{lang}'};" if lang
      end
    end


    class AsyncScripter < SocialButtons::Scripter
      # Place this tag in your head or just before your close body tag
      def script lang = nil
        %Q{<script type="text/javascript" src="https://apis.google.com/js/plusone.js">
          #{language lang}
        </script>}
      end

      def language lang = nil
        "{lang: '#{lang}'}" if lang
      end
    end
  end
end
