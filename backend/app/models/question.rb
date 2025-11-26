class Question < ApplicationRecord
  belongs_to :quiz, inverse_of: :questions

  validates :text, presence: true
  validates :question_type, presence: true, inclusion: { in: %w[mc tf text] }
  validates :correct_answer, presence: true
  validate :options_should_not_be_empty

  private

  # Custom validation to ensure options are present
  def options_should_not_be_empty
    if options.blank? || options.all?(&:blank?)
      errors.add(:options, "can't be blank")
    end
  end
end
