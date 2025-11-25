1. Assumptions:

* There is only one admin user; full authentication/authorization system is not required.
* The admin manages quizzes through a simple React dashboard.
* Admin authentication will use JWT for speed and compatibility with a React frontend.
* Quiz types include:
  * Multiple Choice (MCQ)
  * True/False
  * Short Text
* Public users do not require accounts.
* The goal is to ship a functional MVP within 2 hours, prioritizing core features over full polish.
* API and frontend will be hosted separately on Render, in the same GitHub repository with separate /backend and /frontend folders.

2. Scope:

* Admin
  * JWT login
  * Create quizzes
  * Add questions of multiple types
  * Protected admin-only API endpoints
* Public
  * View quizzes(randomized & paginated)
  * Take quizzes
  * Auto-scoring
  * Show correct answers after submission
* Backend
  * Rails API-only app
  * Postgres database
  * Pagination
  * CORS setup for React
  * Deployable on Render
* Frontend
  * React app with pages for:
    * Admin login
    * Create quiz
    * Quiz list (random + paginated)
    * Take quiz
    * View results
  * Basic styling with simple CSS
  * Environment-based API URL

3. Architecture:
  `React Frontend  →  Rails API  →  Postgres (NeonDB / Render)`

  * Rails API:
    `/admin/login` → returns JWT token
    `/quizzes` → GET (randomized + paginated) / POST (admin only)
    `/quizzes/:id` → GET quiz with questions
    `/quizzes/:id/submit` → POST answers, return score + correct answers

  * React
    * Fetch data via REST API
    * Store JWT in localStorage
    * Use React Router for pages:
    * `/admin/login`
    * `/admin/create`
    * `/quizzes`
    * `/quizzes/:id`
    * `/result`
