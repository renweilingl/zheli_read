class Rank < ApplicationRecord
  audited
  belongs_to :grade
  belongs_to :category
end
