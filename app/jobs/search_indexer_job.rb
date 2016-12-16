# -*- encoding : utf-8 -*-
class SearchIndexerJob < ApplicationJob
  queue_as :default

  # queue_as :search_indexer

  def perform(operation, type, id)
    obj = nil
    type.downcase!

    case type
    when 'project'
      obj = Project.find_by_id(id)
    end

    return false if !obj

    if operation == 'update'
      obj.__elasticsearch__.update_document
    elsif operation == 'delete'
      obj.__elasticsearch__.delete_document
    elsif operation == 'index'
      obj.__elasticsearch__.index_document
    end
  end
end
