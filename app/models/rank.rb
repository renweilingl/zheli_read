class Rank < ApplicationRecord
  audited
  belongs_to :grade
end
