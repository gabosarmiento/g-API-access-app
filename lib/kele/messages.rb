require 'kele/user'
module Messages
  include User
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
