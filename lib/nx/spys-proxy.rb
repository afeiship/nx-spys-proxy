require "net/http"
require "uri"
require "nokogiri"
require "open-uri"

module Nx
  class SpysProxy
    def self.fetch
      data = []
      ports = [3128, 8080, 80]
      proxy_app = SpysProxy.new
      ports.each do |port|
        data += proxy_app.fetch(port)
      end
      data
    end

    def initialize(proxy = "http://127.0.0.1:9090")
      @proxy = proxy
      @ip_re = /\d+\.\d+\.\d+\.\d+/
      @ports = {
        3128 => "1",
        8080 => "2",
        80 => "3",
      }
    end

    def value
      doc = Nokogiri::HTML(
        open(
          "http://spys.one/free-proxy-list/CN/",
          read_timeout: 5,
          proxy: @proxy,
        )
      )

      doc.css('input[name="xx0"]').to_a[0].get_attribute("value")
    end

    def fetch(port)
      uri = URI.parse("http://spys.one/free-proxy-list/CN/")
      data = {
        xx0: value,
        xpp: 0,
        xf1: 0,
        xf2: 0,
        xf4: @ports[port],
        xf5: 1,
      }

      # xf4: 1 -> 3128
      # xf4: 2 -> 8080
      # xf4: 3 -> 80

      # xf5: 1 -> http
      # xf5: 2 -> socket

      # Create the HTTP objects
      http = Net::HTTP.new(uri.host, uri.port, "127.0.0.1", "9090")
      request = Net::HTTP::Post.new(uri.request_uri)
      request.content_type = "application/x-www-form-urlencoded"
      request.body = URI.encode_www_form(data)

      # Send the request
      response = http.request(request)

      doc = Nokogiri::HTML(
        response.body
      )

      table = doc.css("table td > table")[0]
      data = []
      matches = table.text.scan(@ip_re).each do |ip|
        data << { ip: ip, port: port.to_s }
      end

      data.uniq
    end
  end
end
