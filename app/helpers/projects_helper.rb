module ProjectsHelper
  def active_tab(options)
    if current_page?(options)
      'active'
    end
  end
end