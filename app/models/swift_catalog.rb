# == Schema Information
#
# Table name: catalogs
#
#  id                      :integer          not null, primary key
#  name                    :string(191)
#  slug                    :string(191)
#  type                    :string(191)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  categories_count        :integer          default(0)
#  sketch                  :string(191)
#  status                  :integer          default("online")
#  footnote                :text(65535)
#  online_categories_count :integer          default(0)
#

class SwiftCatalog < Catalog

end
