class SubmissionsController < ApplicationController
  load_and_authorize_resource
  before_filter :get_feed
  helper :contents

  def get_feed
    @feed = Feed.find(params[:feed_id])
  end

  def index
    @can_moderate_feed = can?(:update, @feed)
    @submissions = @feed.submissions
    if !@can_moderate_feed
      @submissions = @submissions.approved
    end

    respond_to do |format|
      format.js { }
      format.html { }
    end
  end

  def show
    @submission = Submission.find(params[:id])

    # Enforce the correct feed ID in the URL
    if @submission.feed != @feed
      redirect_to feed_submissions_path(params[:feed_id])
    end

    respond_to do |format|
      format.js { }
      format.html { }
    end
  end

  # PUT /feeds/1/submissions/1
  def update
    @submission = Submission.find(params[:id])
    @submission.moderator = current_user

    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        format.html { redirect_to(feed_submissions_path, :notice => t(:content_moderated)) }
      else
        format.html { redirect_to(feed_submission_path, :notice => t(:content_failed_moderation)) }
      end
    end
  end

end
