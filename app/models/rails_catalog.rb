# == Schema Information
#
# Table name: catalogs
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  slug             :string(255)
#  type             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  categories_count :integer          default(0)
#  sketch           :string(255)
#

class RailsCatalog < Catalog
end
