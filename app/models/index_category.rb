# == Schema Information
#
# Table name: index_categories
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  website          :string(255)
#  index_catalog_id :integer
#  intro            :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class IndexCategory < ApplicationRecord
end
