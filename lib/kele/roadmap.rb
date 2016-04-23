module Roadmap
  # Retrieve roadmaps with their associated sections and checkpoints
  def get_roadmap(roadmap_id)
    response = self.class.get('/roadmaps/' + roadmap_id , headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get('/roadmaps/' + checkpoint_id , headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end
end
