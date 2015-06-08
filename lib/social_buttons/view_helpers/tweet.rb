module SocialButtons
  module Tweet
    include SocialButtons::Assistant

    TWITTER_SHARE_URL = "https://twitter.com/share"
    CLASS = "twitter-share-button"

    def tweet_button(options = {})
      clazz = SocialButtons::Tweet

      # JUNK Code! Refactor!!!!
      params = {}

      params.merge!(url: request.url)
      opt_params = clazz.default_options.merge(options)

      params = clazz.options_to_data_params(opt_params)
      params.merge!(:class => CLASS)

      html = "".html_safe
      html << clazz::Scripter.new(self).script
      html << content_tag(:div, nil, params)
      html
    end

    class << self
      def default_options
        @default_options ||= {
          via:    "tweetbutton",
          text:   "",
          count:  "vertical",
          lang:   "en",
          related: ""
        }
      end
    end

    # Load twitter button once the load event has been fired
    class Scripter < SocialButtons::Scripter
      def script
        return empty_content if widgetized? :tweet
        widgetized! :tweet
        [
          "<script type='text/javascript' id='twitter_loading_sharebtn'>",
            "(function(window, document, undefined){",
              "window.addEventListener('load', function() {",
                "var id = 'twitter_loading_sharebtn',",
                  "target = document.getElementById(id),",
                  "script = document.createElement('script');",
                "script.async = true;",
                "script.src = '#{twitter_wjs}';",
                "script.id = id + '_script';",
                "target.parentNode.insertBefore(script, target);",
              "}, false);",
            "})(window, document);",
          "</script>"
        ].join.html_safe
      end

      def twitter_wjs
        "https://platform.twitter.com/widgets.js"
      end
    end # class
  end
end
