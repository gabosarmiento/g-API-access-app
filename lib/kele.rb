require 'httparty'
class Kele
  include HTTParty
  attr_accessor :auth_token
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @auth_token = self.class.post('/sessions', body: { email: email, password: password })["auth_token"]
    raise StandardError.new('Invalid credentials') unless @auth_token
  end
end
