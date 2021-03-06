require 'test_run_grader'
require 'sandbox_results_saver'

# Receives replies from tmc-sandbox.
class ResultsController < ApplicationController
  skip_authorization_check

  def create
    begin
      submission = Submission.find(params[:submission_id])

      # The sandbox output may contain broken characters e.g. if the student
      # pointed a C char* towards some patch of interesting memory :)
      filtered_params = Hash[params.map {|k, v|
        [k, view_context.force_utf8_violently(v)]
      }]

      SandboxResultsSaver.save_results(submission, filtered_params)
    rescue SandboxResultsSaver::InvalidTokenError
      respond_access_denied('Invalid or expired token')
    else
      render :json => 'OK', :layout => false
    end
  end
end
