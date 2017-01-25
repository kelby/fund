class SpiderBase

  attr_accessor :options,:user_agent

  def options
    @options ||= {
                  :threads              => 4,
                  :verbose              => false,
                  :user_agent           => user_agent,
                  :delay                => 4  ,
                  :depth_limit          => 100,
                  :redirect_limit       => 8,
                  :storage              => nil,
                  :cookies              => cookies.is_a?(String) ? cookies.split(';').map{|c| a = c.split('=') ; [a.first.strip,a.last.strip] }.to_h : cookies ,
                  :accept_cookies       => true,
                  :skip_query_strings   => false,
                  :proxy_host           => nil,
                  :proxy_port           => false,
                  :read_timeout         => 20
                }
    return @options
  end

  def cookies
    nil
  end

  def user_agent
    # "Googlebot/2.1 (+http://www.google.com/bot.html)"
    # "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
  end

  def initialize
    super
    @http = Anemone::HTTP.new(options)
  end

  def dd
    # cookies
  end

  def page_for_url(url)
    page=@http.fetch_pages(url).first
    if !page.error && page.doc
      return page
    else
      return nil
    end
  end

  def json_for_url(url,post_pars=nil)
    json = nil
    body = nil
    begin
      if post_pars == nil
        page=@http.fetch_page(url)
        body = page.body
      else
        uri = URI.parse(url)
        resp = Net::HTTP.post_form(uri, post_pars)
        body = resp.body
      end
      json = JSON.load(body)
    rescue => e
    end
    return json
  end

  def github(url,f=nil)
    g = GithubBot.github(url)
    if g&&f&&g.is_new
      g.f=f
      g.save
    end
    return g
  end

  def email(em)
    if em =~ /@/
      e = Email.where({vaule:em}).first
      if !e
        e = Email.new({vaule:em})
        e.is_new=true
        e.save
      end
      return e
    else
      return nil
    end
  end

  def entity(obj)
    return obj.present? ? obj : nil
  end
end
