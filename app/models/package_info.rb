class PackageInfo < ApplicationRecord
  # from https://packagist.org/search/?tags=laravel

  belongs_to :project
end
