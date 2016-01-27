class Check < ActiveRecord::Base
  belongs_to :lint
  belongs_to :review
end
