class ItemNote < ActiveRecord::Base
  attr_accessible :item_id, :type, :note_id
end
