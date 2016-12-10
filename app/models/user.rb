# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  is_admin               :boolean          default(FALSE)
#

class User < ApplicationRecord
  # Plugins
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github, :google_oauth2]
  # END

  # Associations
  has_many :authentications
  has_many :comments, as: :commentable

  has_many :user_star_projects
  has_many :user_recommend_projects

  has_many :star_projects, through: :user_star_projects, source: :project
  has_many :recommend_projects, through: :user_recommend_projects, source: :project
  # END


  # Validates
  validates_presence_of :name
  validates_uniqueness_of :name
  # END

  # Callbacks
  after_validation :detect_set_name
  # END


  def detect_set_name
    taken_error = I18n.t("errors.messages.taken")

    if self.errors[:name].include?(taken_error)
      self.name += "-g"

      self.remove_errors(:name, :taken)
    end
  end

  # attribute = :name
  # error = :taken
  def remove_errors(attribute, error)
    attribute = attribute.to_sym
    error = error.to_sym

    t_error_key = ['errors', 'messages'].push(error).join(".")

    # remove messages error
    messages = self.errors.messages[attribute]
    messages.delete_if do |message|
      message == I18n.t(t_error_key)
    end

    # remove details error
    details = self.errors.details[attribute]
    details.delete_if do |detail|
      detail[:error] == error
    end
  end

  def self.from_omniauth(access_token)
    provider = access_token.provider
    uid = access_token.uid
    info = access_token.info
    extra = access_token.extra

    _credentials = access_token.credentials
    refresh_token = _credentials["refresh_token"]
    expires = _credentials["expires"]

    authentication = Authentication.where(provider: provider, uid: uid).first

    if authentication.blank?
      user = User.where(:email => info["email"]).first

      if user.blank?
        user = User.new(name: info["name"],
           email: info["email"],
           password: Devise.friendly_token[0, 20]
        )

        user.set_name_from(info)

        user.save!
      end

      user.authentications.create!(provider: provider,
        uid: uid,
        info: info,
        extra: extra,
        refresh_token: refresh_token)
    else
      if expires
        authentication.update_columns refresh_token: refresh_token
      end

      user = authentication.user
    end

    user
  end

  def set_name_by_nickname(nickname)
    if nickname.present?
      self.name = nickname
    end
  end

  def set_name_by_fullname(first_name, last_name)
    if first_name.present? || last_name.present?
      self.name = "#{first_name}#{last_name}"
    end
  end

  def set_name_from(info)
    set_name_by_nickname(info['nickname'])
    set_name_by_fullname(info['first_name'], info['last_name']) if self.name.blank?
  end

  def to_param
    name
  end
end
