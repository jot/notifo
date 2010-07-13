require 'test_helper'

class NotifoTest < Test::Unit::TestCase
  should "probably rename this file and start testing for real" do
    flunk "hey buddy, you should probably rename this file and start testing for real"
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
