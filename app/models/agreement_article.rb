# == Schema Information
#
# Table name: agreement_articles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AgreementArticle < ApplicationRecord
  belongs_to :user
  belongs_to :article, counter_cache: true

  validates_presence_of :user_id
  validates_presence_of :article_id

  validates_uniqueness_of :user_id, scope: :article_id
end
