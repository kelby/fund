# == Schema Information
#
# Table name: fundcompanies
#
#  id                 :integer          not null, primary key
#  project_id         :integer
#  morningstar_number :integer
#  morningstar_name   :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Fundcompany < ApplicationRecord
end
