class QuickrankSnapshotsController < ApplicationController
  def index
    @rating_date = QuickrankSnapshot.pluck(:rating_date).uniq.max

    @quickrank_snapshots = QuickrankSnapshot.where(rating_date: @rating_date).includes(:project)
  end
end
