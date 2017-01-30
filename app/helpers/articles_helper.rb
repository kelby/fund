module ArticlesHelper
  def format_content(content, clazz="")
    _content = sanitize(content, tags: allowed_tags)
    _content = simple_format(_content, class: clazz)

    auto_link(_content, :link => :urls, :html => {:target => '_blank', :rel =>'nofollow' } )
  end

  def allowed_tags
    # 参考 Rails::Html::WhiteListSanitizer.allowed_tags
    # 去掉影响排版的 h1, h2, h3
    # 其余不变
    Set.new(%w(strong em b i p code pre tt samp kbd var sub
      sup dfn cite big small address hr br div span h4 h5 h6 ul ol li dl dt dd abbr
      acronym a img blockquote del ins))
  end
end
