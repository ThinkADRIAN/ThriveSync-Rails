class PreDefinedCard < ActiveRecord::Base
  validates_presence_of :text, :category
end
