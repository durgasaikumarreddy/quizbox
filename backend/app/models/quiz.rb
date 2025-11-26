class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy, inverse_of: :quiz
  accepts_nested_attributes_for :questions

  validates :title, presence: true
  validate :must_have_at_least_one_question
  validate :all_questions_must_be_valid

  private

  # Custom validation to ensure at least one question is associated with the quiz
  def must_have_at_least_one_question
    if questions.empty?
      errors.add(:quiz, "must have at least one question")
    end
  end

  # Custom validation to ensure all associated questions are valid
  def all_questions_must_be_valid
    questions.each_with_index do |question, index|
      next if question.valid?

      question.errors.full_messages.each do |msg|
        errors.add(:question, "#{index + 1}: #{msg}")
      end
    end
  end
end
