require 'test_helper'

class NotifoTest < Test::Unit::TestCase
  
  should 'Notifo#subscribe_user should return a hash' do
    assert NOTIFO.subscribe_user(NOTIFO_USERNAME).kind_of? Hash
  end
  
  should 'Notifo#post should return a hash' do
    assert NOTIFO.post(NOTIFO_USERNAME, "message").kind_of? Hash
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
end
