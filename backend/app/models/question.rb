class Question < ApplicationRecord
  belongs_to :quiz

  validates :text, presence: true
  validates :question_type, presence: true, inclusion: { in: %w[mc tf text] }
  validates :options, presence: true
  validates :correct_answer, presence: true
end
