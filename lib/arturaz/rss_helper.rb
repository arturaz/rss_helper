module Arturaz
  module RssHelper
    # Create an RSS feed. Yield an XML builder object.
    #
    # Options:
    # * :title - feed title
    # * :link - link to the feed
    # * :description - feed description
    # * :language - feed language. Default: en
    #
    def rss(xml, options={})
      [:title, :link].each do |option|
        raise ArgumentError.new(":#{option} must be set") unless options[option]
      end

      xml.instruct! :xml, :version => "1.0" 
      xml.rss(:version => "2.0") do
        xml.channel do
          options.each do |key, value|
            xml.__send__ key, value unless value.nil?
          end
          xml.language('en') unless options[:language]

          yield xml
        end
      end
    end
    
    # Creates RSS autodiscovery link tag which shows that this page has RSS.
    def rss_autodiscovery_link(title, url)
      case url
      when Hash
        url = url_for(url)
      when String
        url = h(url)
      end
      
      "<link rel='alternate' type='application/rss+xml' " +
        "title='#{h title}' href='#{url}' />"
    end
  end
end

ActionView::Base.send :include, Arturaz::RssHelper