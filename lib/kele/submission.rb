require 'kele/user'
module Submission
  include User
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
end
