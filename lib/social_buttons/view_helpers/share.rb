module SocialButtons
  module Share
    include SocialButtons::Assistant

    CLASS = "fb-share-button"

    def share_button(app_id, options = {})
      clazz = SocialButtons::Share
      params = clazz.options_to_data_params(clazz.default_options.merge(options))
      params.merge!(class: CLASS)

      html = "".html_safe
      html << content_tag(:div, nil, id: "fb-root")
      html << clazz::Scripter.new(self).script(app_id)
      html << content_tag(:div, nil, params)
      html
    end

    # To avoid polluting namespace where module is included with util functions!
    class << self
      def default_options
        @default_options ||= {
          layout:  "button_count"
        }
      end
    end

    # Load the Facebook script once the load event has been fired
    class Scripter < SocialButtons::Scripter
      def script(app_id)
        return empty_content if widgetized?(:share) || widgetized?(:like)
        widgetized! :share
        [
        "<script type='text/javascript'>",
          "(function(window, document, undefined){",
            "window.addEventListener('load', function() {",
              "var id = 'fb-root',",
                "target = document.getElementById(id),",
                "script = document.createElement('script');",
              "script.async = true;",
              "script.src = '#{js_sdk}';",
              "script.id = id + '_script';",
              "target.parentNode.insertBefore(script, target);",
            "}, false);",
            "window.fbAsyncInit = function() {",
              "FB.init({ appId: '#{app_id}', status: true, cookie: true, xfbml: true });",
            "};",
          "})(window, document);",
        "</script>"
        ].join.html_safe
      end

      def js_sdk
        "https://connect.facebook.net/en_US/all.js"
      end
    end
  end
end
