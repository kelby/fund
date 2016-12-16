# -*- encoding : utf-8 -*-
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit on: [:create, :update] do
      SearchIndexerJob.perform_later('index', self.class.name, self.id)
    end

    after_commit on: [:destroy] do
      SearchIndexerJob.perform_later('delete', self.class.name, self.id)
    end

    # after_touch  lambda { SearchIndexerJob.perform_later(:update, self.class.to_s, self.id) }
  end
end
