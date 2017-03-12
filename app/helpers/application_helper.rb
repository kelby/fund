module ApplicationHelper
  def magic_paginate(scope, options = {}, &block)
    if browser.device.mobile?
      options[:window] = 1
    else
      options[:window] = 3
    end

    paginate(scope, options, &block)
  end

  def accnav_color(accnav=0)
    return if accnav.blank?

    if accnav > 0
      'red'
    elsif accnav < 0
      'green'
    else
      # ...
    end
  end
end
