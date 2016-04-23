require 'httparty'
# test this code in irb after typing => $: << 'lib'
class Kele
  include HTTParty
  attr_accessor :auth_token
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @auth_token = self.class.post('/sessions', body: { email: email, password: password })["auth_token"]
    raise StandardError.new('Invalid credentials') unless @auth_token
  end

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
end
