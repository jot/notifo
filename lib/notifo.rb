require 'httparty'

class Notifo
  include HTTParty
  base_uri 'https://api.notifo.com/v1'

  # Required Parameters
  # username - notifo service username
  # apikey - notifo service apisecret
  def initialize(username, apisecret)
    @auth = {:username => username, :password => apisecret}
  end
  
  # Required Parameters
  # username - notifo username to subscribe to your service
  def subscribe_user(username)
    options = { :body => {:username => username}, :basic_auth => @auth }
    self.class.post("/subscribe_user", options)
  end
  
  # Required Parameters
  # to - notifo username of recipient
  # msg - message being sent; must be url encoded
  # Optional Parameters
  # title - name of "notification event"
  # uri - the uri that will be loaded when the notification is opened; if specified, must be urlencoded; if a web address, must start with http:// or https://
  def post(username, msg, title=nil, uri=nil)
    options = { :body => {:to => username, :msg => msg, :title=>uri, :uri=>uri}, :basic_auth => @auth }
    self.class.post('/send_notification', options)
  end
end