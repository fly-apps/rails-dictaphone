class Clip < ApplicationRecord
  after_commit -> { broadcast_refresh_later_to("clips") }

  has_one_attached :contents
end
