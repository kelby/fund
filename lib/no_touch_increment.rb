module NoTouchIncrement
  extend ActiveSupport::Concern

  # add your instance methods here
  def increment_column!(attribute, by = 1)
    # "foo"
    increment(attribute, by).update_column(attribute, self[attribute])
  end

  # add your static(class) methods here
  # class_methods do
    #E.g: Order.top_ten
    # def top_ten
    #   limit(10)
    # end
  # end
end

# include the extension
ActiveRecord::Base.send(:include, NoTouchIncrement)
# ActiveRecord::Base.send(:extend, NoTouchIncrement)
