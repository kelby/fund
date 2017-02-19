# == Schema Information
#
# Table name: index_catalogs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  website    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class IndexCatalog < ApplicationRecord
end
