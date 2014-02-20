module SocialButtons
  module Like
    include SocialButtons::Assistant

    CLASS = "fb-like"

    def like_button(app_id, options = {})
      clazz = SocialButtons::Like
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
          send:    "false",
          layout:  "button_count",
          width:   "450",
          action:  "like",
          font:    "arial",
          colorscheme: "light"
        }.merge("show-faces" => "false")
      end
    end

    class Scripter < SocialButtons::Scripter
      def script(app_id)
        return empty_content if widgetized? :like
        widgetized! :like
        [
          "<script src=#{js_sdk} type='text/javascript'></script>",
          "<script>window.fbAsyncInit = function() { FB.init({ appId: '#{app_id}', status: true, cookie: true, xfbml: true }); };</script>",
        ].join.html_safe
      end

      def js_sdk
        "https://connect.facebook.net/en_US/all.js"
      end
    end
  end
end
