require 'test_helper'

class NotifoTest < Test::Unit::TestCase

  context "setup test environment correctly" do
    should "have substituted the username and password into the NOTIFO_BASE_URI constant" do
      assert_equal "https://#{NOTIFO_USERNAME}:#{NOTIFO_API_SECRET}@api.notifo.com/v1", NOTIFO_BASE_URI
    end
  end

  context "container context" do
    setup do
      @response = '{"status":"success","response_code":2201,"response_message":"OK"}'
    end

    context "#verify_webhook_sigature" do
      should "return true if given the right API secret" do
        assert NOTIFO.verify_webhook_signature(WEBHOOK)
      end
  
      should "return false if given the wrong API secret" do
        bad_notifo = Notifo.new NOTIFO_USERNAME, 'thisisntthesecret'
        assert !bad_notifo.verify_webhook_signature(WEBHOOK)
      end
    end

    context "#subscribe user successfully" do
      setup do
        FakeWeb.register_uri(:post, "#{NOTIFO_BASE_URI}/subscribe_user", :body => @response)
      end

      should "subscribe the user" do
        assert_equal @response, NOTIFO.subscribe_user("user") 
      end
    end
  
    context "#send_message successfully" do
      setup do
        FakeWeb.register_uri(:post, "#{NOTIFO_BASE_URI}/send_message", :body => @response)
      end
  
      should "send message to another user via notifo" do
        assert_equal @response, NOTIFO.send_message("user", "message")
      end
    end
  
    context "#send_notification successfully" do
      setup do
        FakeWeb.register_uri(:post, "#{NOTIFO_BASE_URI}/send_notification", :body => @response)
      end

      should "send notification using the new send_notification method" do
        assert_equal @response, NOTIFO.send_notification("user", "message", "title", "http://google.com", "label")
      end

      should "send notification using the old post method" do
        assert_equal @response, NOTIFO.post("user", "message", "title", "http://google.com", "label")
      end
    end
  end
end
