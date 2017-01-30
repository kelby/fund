module ArticlesHelper
  def format_content(content, clazz="")
    _content = sanitize(content, tags: allowed_tags, attributes: allowed_attributes)

    # 这里不用消毒了，因为前一步已经做了
    _content = simple_format(_content, {class: clazz}, sanitize: false, wrapper_tag: 'div')

    # _content = auto_link(_content, :link => :urls, :html => {:target => '_blank', :rel =>'nofollow' } )
  end

  def allowed_tags
    # 参考 Rails::Html::WhiteListSanitizer.allowed_tags
    # 去掉影响排版的 h1, h2, h3
    # 其余不变
    Set.new(%w(strong em b i p code pre tt samp kbd var sub
      sup dfn cite big small address hr br div span h4 h5 h6 ul ol li dl dt dd abbr
      acronym a img blockquote del ins))
  end

  # 参考 Rails::Html::WhiteListSanitizer.allowed_tags
  # 添加了 style
  def allowed_attributes
    Set.new(%w(style href src width height alt
      cite datetime title class name xml:lang abbr))
  end
end
