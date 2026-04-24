class Grade < ApplicationRecord
  has_and_belongs_to_many :compilations, join_table: :compilation_grades
end
