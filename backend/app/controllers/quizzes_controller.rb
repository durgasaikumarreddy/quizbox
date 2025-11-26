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

  # GET /quizzes (public)
  # Returns paginated list of quizzes
  # Query params: page (default: 1)
  # Example response:
  # {
  #   quizzes: [ { id: 1, title: "Sample Quiz" }, ... ],
  #   page: 1,
  #   pages: 5
  # }
  def index
    paginated_quizzes = Quiz.paginate(page: pagination_page, per_page: pagination_per_page)

    render json: {
      quizzes: paginated_quizzes,
      page: paginated_quizzes.current_page,
      total_pages: paginated_quizzes.total_pages
    }
  end

  # GET /quizzes/:id (public)
  # Returns quiz details including paginated questions
  # Query params: page (default: 1)
  # Example response:
  # {
  #   id: 1,
  #   title: "Sample Quiz",
  #   questions: [
  #     { id: 1, text: "Question 1", question_type: "mc", options: ["A", "B", "C"], correct_answer: "A" },
  #     ...
  #   ],
  #   page: 1,
  #   total_pages: 2
  # }
  def show
    quiz = Quiz.find(params[:id])
    paginated_questions = quiz.questions.paginate(page: pagination_page, per_page: pagination_per_page)

    render json: {
      id: quiz.id,
      title: quiz.title,
      created_at: quiz.created_at,
      updated_at: quiz.updated_at,
      questions: paginated_questions,
      page: paginated_questions.current_page,
      total_pages: paginated_questions.total_pages
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Quiz not found' }, status: :not_found
  end

  private

  # Pagination helpers
  def pagination_page
    params[:page] || 1
  end

  def pagination_per_page
    10
  end

  # Strong parameters for quiz creation
  # Expects nested attributes for questions
  def quiz_params
    params.require(:quiz).permit(:title, questions_attributes: [:text, :question_type, :correct_answer, options: []])
  end
end
