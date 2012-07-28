class APIRequest

  def initialize(djMonURL, username, password)
    @djMonURL, @username, @password = djMonURL, username, password
  end

  def execute
    authData = "#{@username}:#{@password}".dataUsingEncoding(NSASCIIStringEncoding)
    authValue = "Basic #{authData.base64Encoding}"
    url = NSURL.URLWithString(@djMonURL)
    request = NSMutableURLRequest.alloc.initWithURL url
    request.setHTTPMethod("GET")
    request.setValue(authValue, forHTTPHeaderField:"Authorization")

    @connection = NSURLConnection.alloc.initWithRequest(request, delegate:self)
  end

  def onSuccess &successHandler
    @successHandler = successHandler
  end

  def onFailure &failureHandler
    @failureHandler = failureHandler
  end

  def connection(connection, didReceiveResponse:response)
    @success = response.statusCode == 200 && response.allHeaderFields.keys.map(&:upcase).include?('DJ-MON-VERSION')
    @data = NSMutableData.alloc.init
  end

  def connection(connection, didReceiveData:data)
    @data.appendData(data)
  end

  def connectionDidFinishLoading(connection)
    @success ? @successHandler.call(parseJSON(@data)) : @failureHandler.call
  end

  def connection(connection, didFailWithError:error)
    @failureHandler.call
  end

  private

  def parseJSON data
    errorPtr = Pointer.new(:object)
    json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:errorPtr)
    raise errorPtr[0] unless json
    json
  end

end
