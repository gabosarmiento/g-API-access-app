require 'kele/roadmap'
require 'httparty'
# test this code in irb after typing => $: << 'lib'
class Kele
  include HTTParty
  include Roadmap
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
  # Retrieve a list of a mentor's available time slots for the current user
  def get_mentor_availability(mentor_id)
    # mentor_id could be replaced with {current_enrollment['mentor_id']} form response
    response = self.class.get('/mentors/' + mentor_id + '/student_availability', headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
  
end
