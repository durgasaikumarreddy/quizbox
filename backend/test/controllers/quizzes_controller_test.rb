require 'test_helper'

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:one)
  end

  # Create quiz tests
  test "should create quiz as admin" do
    token = encode_token({ admin_id: @admin.id })

    post '/quizzes',
      params: {
        quiz: {
          title: 'New Quiz',
          questions_attributes: [
            {
              text: 'Question 1',
              question_type: 'mc',
              options: ['A', 'B', 'C'],
              correct_answer: 'A'
            }
          ]
        }
      },
      headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal 'New Quiz', json_response['title']
  end

  test "should not create quiz without authorization" do
    post '/quizzes',
      params: {
        quiz: {
          title: 'New Quiz',
          questions_attributes: []
        }
      }

    assert_response :unauthorized
  end

  test "should not create quiz with invalid params" do
    token = encode_token({ admin_id: @admin.id })

    post '/quizzes',
      params: {
        quiz: {
          title: '',
          questions_attributes: []
        }
      },
      headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response.key?('errors')
  end

  test "should not create quiz without title" do
    token = encode_token({ admin_id: @admin.id })

    post '/quizzes',
      params: {
        quiz: {
          title: '',
          questions_attributes: [
            { text: 'Q', question_type: 'mc', options: ['A'], correct_answer: 'A' }
          ]
        }
      },
      headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_includes json_response['errors'].join(', '), "Title can't be blank"
  end

  test "should not create quiz without any questions" do
    token = encode_token({ admin_id: @admin.id })

    post '/quizzes',
      params: {
        quiz: {
          title: 'No Questions',
          questions_attributes: []
        }
      },
      headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    # Custom validation adds an error message on quiz
    assert_match %r{must have at least one question}i, json_response['errors'].join(', ')
  end

  test "should not create quiz when a question is invalid (missing text)" do
    token = encode_token({ admin_id: @admin.id })

    post '/quizzes',
      params: {
        quiz: {
          title: 'Bad Question',
          questions_attributes: [
            { text: '', question_type: 'mc', options: ['A'], correct_answer: 'A' }
          ]
        }
      },
      headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    # The quiz aggregates question errors with a prefix like 'Quiz Question 1: Text can't be blank'
    assert_match(
      %r{Question 1: .*Text can't be blank|Question 1: .*text can't be blank}i,
      json_response['errors'].join(', ')
    )
  end

  test "should not create quiz when question has invalid type or missing options" do
    token = encode_token({ admin_id: @admin.id })

    # invalid question_type
    post '/quizzes',
      params: {
        quiz: {
          title: 'Invalid Type',
          questions_attributes: [
            { text: 'Q', question_type: 'invalid_type', options: ['A'], correct_answer: 'A' }
          ]
        }
      },
      headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_match(
      %r{Question 1: .*included in the list|Question 1: .*is not included in the list}i,
      json_response['errors'].join(', ')
    )

    # missing options for mc question
    post '/quizzes',
      params: {
        quiz: {
          title: 'No Options',
          questions_attributes: [
            { text: 'Q', question_type: 'mc', options: [], correct_answer: 'A' }
          ]
        }
      },
      headers: { 'Authorization' => "Bearer #{token}" }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_match(
      %r{Question 1: .*Options can't be blank|Question 1: .*options can't be blank}i,
      json_response['errors'].join(', ')
    )
  end

  # Index tests
  test "should get index" do
    get '/quizzes'

    assert_response :success
    json_response = JSON.parse(response.body)

    assert json_response.key?('quizzes')
    assert_equal 1, json_response['page']
    assert_equal 1, json_response['total_pages']
    assert_equal 5, json_response['quizzes'].length

    # Verify structure of first quiz
    first_quiz = json_response['quizzes'][0]
    assert first_quiz.key?('id')
    assert first_quiz.key?('title')
    assert_equal 'General Knowledge Quiz', first_quiz['title']
  end

  test "should paginate index" do
    # Request a page beyond available pages
    get '/quizzes', params: { page: 2 }

    assert_response :success
    json_response = JSON.parse(response.body)

    assert_equal 2, json_response['page']
    assert_equal 1, json_response['total_pages']
    assert_equal 0, json_response['quizzes'].length
  end

  # Show tests
  test "should get quiz show" do
    quiz = quizzes(:one)
    get "/quizzes/#{quiz.id}"

    assert_response :success
    json_response = JSON.parse(response.body)

    assert_equal quiz.id, json_response['id']
    assert_equal quiz.title, json_response['title']
    assert json_response.key?('questions')
    assert json_response.key?('page')
    assert json_response.key?('total_pages')
    assert_equal 1, json_response['page']
  end

  test "should not get quiz show with invalid id" do
    get '/quizzes/99999'

    assert_response :not_found
  end

  test "should paginate questions in show" do
    quiz = quizzes(:one)

    # Page 1
    get "/quizzes/#{quiz.id}", params: { page: 1 }

    assert_response :success
    json_response = JSON.parse(response.body)

    assert_equal 1, json_response['page']
    assert json_response['questions'].length.positive?

    # Page 2 (beyond available questions for quiz one)
    get "/quizzes/#{quiz.id}", params: { page: 2 }

    assert_response :success
    json_response = JSON.parse(response.body)

    assert_equal 2, json_response['page']
    assert_equal 0, json_response['questions'].length
  end

  private

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key.to_s, 'HS256')
  end
end
