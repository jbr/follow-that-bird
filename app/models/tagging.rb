class Tagging < ActiveRecord::Base
  belongs_to :syntax
  belongs_to :tweet
end
