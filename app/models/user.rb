class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github, :google_oauth2]

  has_many :authentications

  validates_presence_of :name

  def self.from_omniauth(access_token)
    provider = access_token.provider
    uid = access_token.uid
    info = access_token.info
    extra = access_token.extra

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
        extra: extra)
    else
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
end
