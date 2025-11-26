class QuizzesController < ApplicationController
  include JwtHelper

  before_action :authorize_admin, only: [:create]

  # POST /quizzes (admin only)
  # Creates a new quiz with questions
  # Expects params:
  # { quiz:
  #    {
  #       title: "Quiz Title", questions_attributes: [
  #         { text: "Q1", question_type: "mc", options: ["A", "B"], correct_answer: "A" }, ...
  #       ]
  #     }
  # }
  # Example response:
  # { id: 1, title: "Quiz Title", questions: [ ... ] }
  def create
    quiz = Quiz.new(quiz_params)

    if quiz.save
      render json: quiz, status: :created
    else
      render json: { errors: quiz.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for quiz creation
  # Expects nested attributes for questions
  def quiz_params
    params.require(:quiz).permit(:title, questions_attributes: [:text, :question_type, :correct_answer, options: []])
  end
end
