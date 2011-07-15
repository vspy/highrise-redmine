require 'net/http'

class HighriseRedmine

  class Http 

    def get(url, username = nil, password = nil)
      request = Net::HTTP::Get.new(path(url))
      setPassword(request, username, password) 
      getResponse(url, request) 
    end   

    def post(url, body, username = nil, password = nil)
      request = Net::HTTP::Post.new(path(url))
      request.body = body
      setPassword(request, username, password) 
      getResponse(url, request)  
    end

    def setPassword(request, u, p) 
      if (u && p)
        request.basic_auth u,p
      end
    end

    def path(url) 
      (url.query.nil?) ? url.path : "#{url.path}?#{url.query}"
    end

    def getResponse(url, request)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      response = http.request(request)
      raise "Response was not 200, response was #{response.code} (url is #{url}): #{response.body}" if response.code != "200"
      return response.body
    end
  end

end
