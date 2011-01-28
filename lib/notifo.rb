require 'httparty'
require 'cgi'
require 'digest/sha1'

# Simple client class for the Notifo API.
class Notifo
  include HTTParty
  base_uri 'https://api.notifo.com/v1'

  # Create a new client instance. Must be supplied with the username and
  # api_secret for your service.
  #
  # Required Parameters:
  # username - notifo service username
  # api_secret - notifo service api secret
  def initialize(username, api_secret)
    @auth = { :username => username, :password => api_secret }
  end
  
  # Subscribe a user to your service. This sends them a message confirming they 
  # want to use the service.
  #
  # Required Parameters:
  # username - notifo username to subscribe to your service
  def subscribe_user(username)
    options = { :body => { :username => username }, :basic_auth => @auth }
    self.class.post("/subscribe_user", options)
  end
  
  # Send a notification to the specified user. You will only be allowed to send
  # notifications to users who have previously subscribed to your service.
  #
  # Required Parameters:
  # username - notifo username of recipient
  # message - message being sent; must be url encoded
  #
  # Optional Parameters:
  # title - name of "notification event"
  # uri - the uri that will be loaded when the notification is opened; if specified, must be urlencoded; if a web address, must start with http:// or https://
  # label - label describing the "application" (used only if being sent from a User account; the Service label is automatically applied if being sent from a Service account) 
  def send_notification(username, message, title = nil, uri = nil, label = nil)
    options = { :body => {:to => username, :msg => message, :label => title, :title => title, :uri => uri}, :basic_auth => @auth }
    self.class.post('/send_notification', options)
  end

  def post(username, message, title = nil, uri = nil, label = nil) # :ndoc:
    warn "DEPRECATION WARNING: the 'post' method is deprecated. Use 'send_notification' instead"
    send_notification(username, message, title, uri, label)
  end

  # Required Parameters:
  # params - the hash of params the webhook passed to you. All keys must be *Strings*, not symbols.
  def verify_webhook_signature(params)
    signature = params['notifo_signature']
    other_notifo_params = params.reject {|key,val| !(key =~ /\Anotifo_/ && key != "notifo_signature")}
    str = other_notifo_params.keys.sort.map do |key|
      params[key]
    end.join
    str << @auth[:password]

    signature == Digest::SHA1.hexdigest(CGI::escape(str))
  end

  # Send a message to a specific Notifo user. Messages are slightly different
  # from notifications in that they are permitted to be sent to users who
  # haven't subscribed.
  #
  # Required Parameters:
  # username - notifo username of recipient
  # message - message being sent; must be url encoded
  def send_message(username, message)
    options = { :body => { :to => username, :msg => message }, :basic_auth => @auth }
    self.class.post('/send_message', options)
  end
end
