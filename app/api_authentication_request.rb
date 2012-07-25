class APIAuthenticationRequest

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
    @data = NSMutableData.alloc.init
  end

  def connection(connection, didReceiveData:data)
    @data.appendData(data)
  end

  def connectionDidFinishLoading(connection)
    @successHandler.call
  end

  def connection(connection, didFailWithError:error)
    @connection = nil
    @data = nil
    @failureHandler.call
  end

end
