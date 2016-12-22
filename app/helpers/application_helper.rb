module ApplicationHelper
  def magic_paginate(scope, options = {}, &block)
    if browser.device.mobile?
      options[:window] = 1
    else
      options[:window] = 3
    end

    paginate(scope, options, &block)
  end
end
