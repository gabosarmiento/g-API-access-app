module Roadmap
  # Retrieve roadmaps with their associated sections and checkpoints
  def get_roadmap(roadmap_id)
    response = self.class.get('/roadmaps/' + roadmap_id , headers: { "content_type" => 'application/json', "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get('/checkpoints/' + checkpoint_id , headers: { "content_type" => 'application/json', "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end
end
