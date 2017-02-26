# == Schema Information
#
# Table name: developers
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  avatar            :string(255)
#  github_id         :integer
#  public_repos      :integer
#  subscribers_count :integer
#  watchers_count    :integer
#  forks_count       :integer
#  identity          :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  eastmoney_url     :string(255)
#  take_office_date  :date
#  description       :text(65535)
#  age               :integer          default(0)
#  degree            :string(255)
#  eastmoney_code    :string(255)
#  sina_code         :string(255)
#  rh_at             :date
#  catalog_id        :integer
#  status            :integer          default("online")
#  slug              :string(255)
#

class Developer < ApplicationRecord
  # Associations
  has_many :catalog_developers
  # 就职过的基金公司（两者是多对多关联，虽然一个基金经理就职过多个基金公司的情况比较少，但仍然是多对多）
  has_many :catalogs, through: :catalog_developers

  has_many :developer_projects
  # 基金
  has_many :projects, through: :developer_projects

  # 当前就职的基金（这个关系是孤立的，catalog 那边没有 has_many）
  belongs_to :catalog
  # END


  # Plugins
  mount_uploader :avatar, AvatarUploader
  # END


  # Constants
  GITHUB_URL = "https://github.com/"
  # END


  delegate :name, to: :catalog, allow_nil: true, prefix: true
  enum status: { online: 0, offline: 1 }


  # Callbacks
  # after_create :set_projects_data
  # after_create :delay_set_avatar
  # END

  # Validates
  validates_uniqueness_of :name, scope: :eastmoney_url
  # validates_presence_of :catalog_id
  # validates_presence_of :name, scope: :catalog_id
  # END


  # Callbacks
  before_create :set_slug
  # END


  def self.set_eastmoney_code
    self.find_each do |developer|
      eastmoney_code = developer.eastmoney_url.split(/\/|\./)[-2]
      developer.update_columns(eastmoney_code: eastmoney_code)
    end
  end

  def self.create_developer_from_projects
    Project.where(developer_id: nil).includes(:developer).joins(:github_info).find_each do |project|
      developer = Developer.find_or_create_by(name: project.author)

      if project.developer_id.blank? && developer.present?
        project.update_columns(developer_id: developer.id)
      end
    end
  end

  def self.set_developer_info(project_id)
    project = Project.find(project_id)

    developer = Developer.find_or_create_by(name: project.author)

    project.update_columns(developer_id: developer.id)
  end

  def self.set_avatar(developer_id)
    developer = Developer.find(developer_id)

    developer.set_avatar

    if developer.changed?
      developer.save
    end
  end

  def set_avatar
    if self.avatar.file.blank?
      begin
        self.remote_avatar_url = self.projects.last.github_info['others']['owner']['avatar_url']
      rescue Exception => e
        # ...
      end
    end
  end

  def delay_set_avatar
    developer_id = self.id

    Developer.delay.set_avatar(developer_id)
  end

  def self.set_projects_data(developer_id)
    developer = Developer.find(developer_id)

    developer.set_projects_data

    if developer.changed?
      developer.save
    end
  end

  def set_projects_data
    # self.subscribers_count = GithubInfo.where(project_id: project_ids).sum(:subscribers_count)
    # self.watchers_count = GithubInfo.where(project_id: project_ids).sum(:watchers_count)
    # self.forks_count = GithubInfo.where(project_id: project_ids).sum(:forks_count)

    if self.changed?
      self.save
    end
  end

  def project_ids
    self.projects.ids
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '')
  end
end
