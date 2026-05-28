class RankContent < ApplicationRecord
  audited

  belongs_to :rank
  belongs_to :compilation, optional: true
  belongs_to :book, optional: true
end
