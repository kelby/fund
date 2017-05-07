module QuickranksHelper
  def checked_rating(rating_type, item)
    if params[rating_type].blank?
      return false
    end

    rating_value = params[rating_type].map &:to_i

    rating_value.include? item
  end

  def checked_delivery_style(item)
    if params['delivery_style'].blank?
      return false
    end

    rating_value = params['delivery_style'].map &:to_i

    rating_value.include? item
  end
end