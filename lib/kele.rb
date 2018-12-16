require './lib/roadmap'
require 'httparty'
require 'pp'
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

  # submissions begins

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    student_enrollment_id = get_me["current_enrollment"]['id']
    data = {
      assignment_branch: assignment_branch,
      assignment_commit_link: assignment_commit_link,
      checkpoint_id: checkpoint_id,
      comment: comment,
      enrollment_id: student_enrollment_id
    }
    data.delete_if { |k, v| v.nil? }
    response = self.class.post('/checkpoint_submissions', headers: { "authorization" => @auth_token }, body: data)
    @submission = JSON.parse(response.body)
    pp @submission
  end
  # submission ends
  # messages begins

  def get_messages(arg = nil)
    if arg.nil? #if no page number specified - get total number of messages
      response = self.class.get("/message_threads", headers: { "authorization" => @auth_token })
      #make as many requests as there are pages, +1 to round up
      @messages = (1..(response["count"]/10 + 1)).map do |n|
             self.class.get("/message_threads", body: { page: n }, headers: { "authorization" => @auth_token })
          end
      pp @messages
    else
      response = self.class.get("/message_threads", body: { page: arg }, headers: { "authorization" => @auth_token })
      @messages = JSON.parse(response.body)
      pp @messages
    end
  end

  def create_message(subject = nil, body = nil, token = nil)
   user = get_me
   data = {
     user_id: user["id"],
     recipient_id: user["current_enrollment"]['mentor_id'],
     token: token,
     subject: subject,
     "stripped-text" => body
   }
   data.delete_if { |k, v| v.nil? }

   response = self.class.post("/messages", headers: { "authorization" => @auth_token }, body: data)

   @message = JSON.parse(response.body)
   pp @message
 end

end
