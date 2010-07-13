require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'notifo'

class Test::Unit::TestCase
end

NOTIFO_USERNAME = 'testing42'
NOTIFO_API_SECRET = 'x96cb52807a33bafc8fd741eeba5e40ff89f05896'

NOTIFO = Notifo.new NOTIFO_USERNAME, NOTIFO_API_SECRET

WEBHOOK = YAML::load(File.read('test/assets/webhook_params.yaml'))
