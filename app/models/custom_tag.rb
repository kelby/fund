class CustomTag < ::ActsAsTaggableOn::Tag
  before_create :set_slug

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: "")
  end

  def to_param
    self.slug.presence || "#{self.id}"
  end
end
