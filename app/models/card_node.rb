class CardNode < ActiveRecord::Base
  default_scope { where('code NOT LIKE ?', '00%') }
end
