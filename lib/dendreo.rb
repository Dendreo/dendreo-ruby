require "dendreo/version"
require 'net/http'
module Dendreo
  class API
    attr_accessor :url
    attr_accessor :api_key

    def initialize(url, api_key)
      @url = url #exemple = https://pro.dendreo.com/my_company/api
      @api_key = api_key
    end

    def method_missing(method_name, *args)
      method_name_string = method_name.to_s
      request_method = args.first[:method]
      datas = args.any? ? args.first[:datas] : {}
      case request_method
      when "get"
        args_formatted = format_args_to_url(datas)
        url = "#{@url}/#{method_name_string}.php?key=#{@api_key}#{args_formatted}"
        puts url
        get(url)
      when "post"
        post("#{@url}/#{method_name_string}.php?key=#{@api_key}", args.first[:datas])
      end
    end

    private

    def post( url, options = {})
      uri = URI(url)
      result = Net::HTTP.post_form(uri, options)
      res = result == "" ? "[{}]" : result.body
      JSON.parse(res)
    end

    def get(url)
      uri = URI(url)
      result = Net::HTTP.get(uri)
      res = result == "" ? "[{}]" : result
      JSON.parse(res)
    end

    def format_args_to_url(args = {})
      args.any? ? args.map{|k, v| k == args.keys.first ? "&#{k}=#{v}" : "#{k}=#{v}" }.join("&") : ""
    end

  end
end
