class Markdown
  def self.markdown
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def self.render(content)
    markdown.render(content)
  end
end
