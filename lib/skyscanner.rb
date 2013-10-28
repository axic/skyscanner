require 'faraday'
require 'multi_json'

module Skyscanner
  class Connection
    class << self; self; end.class_eval do
      def adapter; @@adapter ||= :net_http; end
      def adapter=(input); @@adapter = input; end

      def site_redirect(*args); new.site_redirect(*args); end
      def browse_quotes(*args); new.browse_quotes(*args); end
      def browse_grid(*args); new.browse_grid(*args); end
      def browse_routes(*args); new.browse_routes(*args); end
      def browse_dates(*args); new.browse_dates(*args); end

      def events(*args); new.events(*args); end

      def logger; @@logger ||= nil; end
      def logger=(input); @@logger = input; end

      def options
        {
          :adapter => adapter,
          :logger => logger,
          :protocol => protocol,
          :response_format => response_format,
          :url => url,
          :version => version,
          :api_key => apikey
        }
      end

      def performers(*args); new.performers(*args); end

      def protocol; @@protocol ||= :http; end
      def protocol=(input); @@protocol = input; end

      def response_format; @@response_format ||= :ruby; end
      def response_format=(input); @@response_format = input; end

      def taxonomies(*args); new.taxonomies(*args); end

      def url; @@url ||= "partners.api.skyscanner.net/apiservices"; end
      def url=(input); @@url = input; end

      def venues(*args); new.venues(*args); end

      def version; @@version ||= "v1.0"; end
      def version=(input); @@version = input; end

      def apikey; @@api_key end
      def apikey=(input); @@api_key = input; end
    end

    def initialize(options = {})
      @options = self.class.options.merge({}.tap do |opts|
        options.each do |k, v|
          opts[k.to_sym] = v
        end
      end)
    end

    def handle_response(response)
      if response_format == :ruby and response.status == 200
        MultiJson.decode(response.body)
      else
        { :status => response.status, :body => response.body }
      end
    end

    # Ruby 1.8.7 / ree compatibility
    def id
      @options[:id]
    end

    def request(url, segments, params)
      handle_response(Faraday.new(*builder(url, segments_to_path(segments, params), params.clone)) do |build|
        build.adapter adapter
        #        build.use Faraday::Response::VerboseLogger, logger unless logger.nil?
      end.get)
    end

    def response_format
      @options[:response_format].to_sym
    end

    def api_key
      @options[:api_key]
    end

    def segments_to_path(segments, params)
      out = []
      segments.each do |k, v|
        value = params[k]
        if value then
          out << value
        elsif v then
          raise ArgumentError.new("Mandatory parameter (#{k}) missing")
        end
      end
      out.join('/')
    end

    def site_redirect(params = {})
      segments = {
        :country => true,
        :currency => true,
        :locale => true,
        :originPlace => true,
        :destinationPlace => true,
        :outboundPartialDate => true,
        :inboundPartialDate => false,
        :associateID => false,
        :utm_source => false,
        :utm_medium => false,
        :utm_name => false
      }

#      request('skyscannerredirect', segments, params)
      # Life isn't that easy - in this case the constructed URL is what we return
      ret = builder("skyscannerredirect", segments_to_path(segments, params), params.clone)
      "#{ret[0]}?apiKey=#{api_key}"
    end

    def browse_quotes(params = {})
      segments = {
        :country => true,
        :currency => true,
        :locale => true,
        :originPlace => true,
        :destinationPlace => true,
        :outboundPartialDate => true,
        :inboundPartialDate => false
      }
      request('browsequotes', segments, params)
    end

    def browse_grid(params = {})
      segments = {
        :country => true,
        :currency => true,
        :locale => true,
        :originPlace => true,
        :destinationPlace => true,
        :outboundPartialDate => true,
        :inboundPartialDate => false
      }
      request('browsegrid', segments, params)
    end

    def browse_routes(params = {})
      segments = {
        :country => true,
        :currency => true,
        :locale => true,
        :originPlace => true,
        :destinationPlace => true,
        :outboundPartialDate => true,
        :inboundPartialDate => false
      }
      request('browseroutes', segments, params)
    end

    def browse_dates(params = {})
      segments = {
        :country => true,
        :currency => true,
        :locale => true,
        :originPlace => true,
        :destinationPlace => true,
        :outboundPartialDate => true,
        :inboundPartialDate => false
      }
      request('browsedates', segments, params)
    end

    def endpoint_uri(method)
      "#{protocol}://#{url}/#{method}/#{version}/"
    end

    def uri(path)
      "#{protocol}://#{url}/#{path}/#{version}"
    end

    private

    def method_missing(method, *params)
      @options.keys.include?(method.to_sym) && params.first.nil? ? @options[method.to_sym] : super
    end

    def builder(uri_segment, path, params)
      return [
        [].tap do |part|
          part << endpoint_uri(uri_segment)
          part << path
          part << "/#{params.delete(:id)}" unless params[:id].nil?
        end.join,
        {
          :params => custom_options.merge(([:jsonp, :xml].include?(response_format) ? \
          params.merge(:format => response_format) : params)).merge(:apiKey => api_key)
        }
      ]
    end

    def custom_options
      @custom_options ||= {}.tap do |opts|
        ignore = self.class.options.keys
        @options.each do |k, v|
          opts[k] = v unless ignore.include?(k)
        end
      end
    end
  end
end
