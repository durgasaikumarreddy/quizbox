# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#  Create Admin
Admin.create!(
  email: "admin@example.com",
  password: "password123"
)

# General Knowledge Quiz - India
Quiz.create!(
  title: "India - General Knowledge",
  questions_attributes: [
    {
      text: "What is the capital of India?",
      question_type: "mc",
      options: ["Mumbai", "New Delhi", "Bangalore", "Kolkata"],
      correct_answer: "New Delhi"
    },
    {
      text: "The Taj Mahal is located in which state?",
      question_type: "mc",
      options: ["Delhi", "Uttar Pradesh", "Agra", "Madhya Pradesh"],
      correct_answer: "Uttar Pradesh"
    },
    {
      text: "How many states does India have (as of 2024)?",
      question_type: "mc",
      options: ["26", "28", "29", "31"],
      correct_answer: "28"
    }
  ]
)

# Ruby Programming Quiz
Quiz.create!(
  title: "Ruby Programming Basics",
  questions_attributes: [
    {
      text: "What is the correct way to create a symbol in Ruby?",
      question_type: "mc",
      options: ["&symbol", ":symbol", "#symbol", "$symbol"],
      correct_answer: ":symbol"
    },
    {
      text: "Ruby is an object-oriented programming language.",
      question_type: "tf",
      options: ["true", "false"],
      correct_answer: "true"
    },
    {
      text: "Which method is used to get the length of an array in Ruby?",
      question_type: "mc",
      options: ["size()", "len()", "length()", "Both size() and length()"],
      correct_answer: "Both size() and length()"
    }
  ]
)

# JavaScript Quiz
Quiz.create!(
  title: "JavaScript Essentials",
  questions_attributes: [
    {
      text: "Which keyword is used to declare a variable with function scope in JavaScript?",
      question_type: "mc",
      options: ["let", "const", "var", "static"],
      correct_answer: "var"
    },
    {
      text: "Arrow functions in JavaScript use the '=>' syntax.",
      question_type: "tf",
      options: ["true", "false"],
      correct_answer: "true"
    },
    {
      text: "What does 'async' keyword do in JavaScript?",
      question_type: "mc",
      options: ["Makes code asynchronous", "Declares a function that returns a Promise", "Enables automatic type checking", "Both 'Makes code asynchronous' and 'Declares a function that returns a Promise'"],
      correct_answer: "Both 'Makes code asynchronous' and 'Declares a function that returns a Promise'"
    }
  ]
)

# React Quiz
Quiz.create!(
  title: "React Fundamentals",
  questions_attributes: [
    {
      text: "What is the smallest unit of React that can be rendered?",
      question_type: "mc",
      options: ["Component", "Element", "State", "Props"],
      correct_answer: "Element"
    },
    {
      text: "React uses a virtual DOM to improve performance.",
      question_type: "tf",
      options: ["true", "false"],
      correct_answer: "true"
    },
    {
      text: "Which hook is used to perform side effects in functional components?",
      question_type: "text",
      options: ["useEffect"],
      correct_answer: "useEffect"
    }
  ]
)

# Advanced Ruby Quiz
Quiz.create!(
  title: "Ruby on Rails Development",
  questions_attributes: [
    {
      text: "Which of these is NOT a default Rails directory?",
      question_type: "mc",
      options: ["app", "config", "lib", "static"],
      correct_answer: "static"
    },
    {
      text: "Rails models automatically create an id primary key column.",
      question_type: "tf",
      options: ["true", "false"],
      correct_answer: "true"
    },
    {
      text: "What is the purpose of Rails migrations?",
      question_type: "text",
      options: ["Managing database schema changes"],
      correct_answer: "Managing database schema changes"
    }
  ]
)

puts "Created #{Quiz.count} quizzes with #{Question.count} questions"
puts "Quiz topics: India, Ruby Programming, JavaScript, React, and Ruby on Rails"
