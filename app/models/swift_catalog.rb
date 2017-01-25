# == Schema Information
#
# Table name: catalogs
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  slug                    :string(255)
#  type                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  categories_count        :integer          default(0)
#  sketch                  :string(255)
#  status                  :integer          default("online")
#  footnote                :text(65535)
#  online_categories_count :integer          default(0)
#  initial                 :integer          default("initial_unknow")
#  short_name              :string(255)
#  founder                 :string(255)
#  set_up_at               :date
#  scale                   :string(255)
#  scale_record_at         :date
#  code                    :string(255)
#  raw_show_html           :text(65535)
#  projects_count          :integer          default(0), not null
#

class SwiftCatalog < Catalog

end
