class Modification < ActiveRecord::Base
  belongs_to :tender
  serialize :data, Array
end
