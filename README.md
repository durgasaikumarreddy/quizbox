# 📦 QuizBox

QuizBox is a full-stack **Quiz Management Platform** built using:

- **Ruby on Rails (API-only)**  
- **React (Create React App)**  
- **JWT-based Admin Authentication**  
- **Quiz Listing + Pagination**  
- **Single Monorepo Structure**  
- **Deployed on Render** (Rails API + React Static Site)

It allows public users to browse random quizzes and admins to create quiz content securely.

---

## 🚀 Features

### 👤 Public
- Randomized quiz display on every request  
- Pagination support  
- Clean, responsive UI  
- Fast load time  

### 🔐 Admin
- Secure JWT-based login
- Create quizzes
- Access protected API routes
- React admin panel with Axios interceptor

---

## 🏗 Project Structure

```
quizbox/
│
├── backend/             # Rails 7 API-only backend
│   ├── app/
│   ├── config/
│   ├── db/
│   └── ...
│
├── frontend/            # React 18 frontend
│   ├── src/
│   ├── public/
│   └── ...
│-- plan.md
└── README.md
```

---

## 🛠 Tech Stack

### Backend (Rails)
- Ruby on Rails 7 (API mode)
- PostgreSQL
- JWT Authentication
- Will Paginate
- Rack-CORS for frontend access

### Frontend (React)
- React (CRA)
- Axios (with auth interceptor)
- React Router
- Simple CSS (no frameworks)

### DevOps
- Render (Static Site + Web Service)
- Environment variables for secure config

---

# ⚙️ Local Setup

## 1. Clone the Repo

```bash
git clone https://github.com/durgasaikumarreddy/quizbox.git
cd quizbox
```

---

# 🔧 Backend Setup (Rails)

```bash
cd backend
bundle install
rails db:create
rails db:migrate
rails s
```

Backend runs at:

```
http://localhost:3000
```

---

# 🎨 Frontend Setup (React)

```bash
cd frontend
npm install
npm start
```

Frontend runs at:

```
http://localhost:3001
```

---

# 🔐 Environment Variables

## Frontend (`frontend/.env`)

```
REACT_APP_API_BASE_URL=http://localhost:3000
```

## Backend (`backend/.env`)

```
  DB_NAME=quizbox
  DB_HOST=...
  DB_USERNAME=...
  DB_PASSWORD=...
  SECRET_KEY_BASE=...
```

---

# 🔑 Authentication Flow

1. Admin submits login form  
2. Rails validates credentials  
3. Rails returns a JWT token  
4. Token is stored in `localStorage`  
5. Axios automatically attaches token:

```js
config.headers.Authorization = `Bearer ${token}`;
```

6. Protected endpoints check the token

---

# 📄 API Documentation

Full documentation is included below in this README under  
➡ **“📚 Full API Documentation”**.

---

# 🌐 Deployment (Render)

### live url

https://quizbox-fe.onrender.com/

---

# ⭐ Support

If you like QuizBox, leave a ⭐ on GitHub!  
Your support keeps the project active and growing.

---

# 📚 Full API Documentation

## Base URL

```
http://localhost:3000
```
---

# 🔓 Public Endpoints

---

## **GET /quizzes**

Retrieve quizzes with pagination.

### Query Params:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | integer | 1 | Page number |

### Example:
```
GET /quizzes?page=1
```

### Response:
```json
{
  "quizzes": [
    {
      "id": 1,
      "title": "Simple quiz"
    }
    ...
  ],
  "meta": {
    "page": 1,
    "total_pages": 7,
    "total_count": 70
  }
}
```

---

## **GET /quizzes/:id**

### Query params:
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | integer | 1 | Page number |

### Example:
```
GET /quizzes/1/page=1
```

### Response:
```
{
  id: 1,
  title: "Sample Quiz",
  questions: [
    { id: 1, text: "Question 1", question_type: "mc", options: ["A", "B", "C"], correct_answer: "A" },
    ...
  ],
  page: 1,
  total_pages: 2
}
```

---

## **POST /quizzes/:id/submit**

### Example:
```
POST /quizzes/1/submit
```

### Params:
```
{
  "answers": {
    "1": "A", # 1 is question id and A is user's answer 
    ...
  }
}
```

### Response:
```
{
  "score": 3,
  "total": 4,
  "results": [
    {
      "question_id": 1,
      "question_text": "Question 1",
      "correct": true,
      "user_answer": "A",
      "correct_answer": "A"
    },
    ...
  ]
}
```

---

# 🔐 Admin Authentication

---

## **POST /admin/login**

### Request:
```json
{
  "email": "admin@example.com",
  "password": "password123"
}
```

### Response:
```json
{
  "token": "your.jwt.token",
  "admin": {
    "id": 1,
    "email": "admin@example.com"
  }
}
```

---

# 🔒 Protected Admin Endpoint

> Require header:

```
Authorization: Bearer <token>
```

---

## **POST /admin/quizzes**

Create a quiz.

### Request:
```json
{
  "quiz": {
    "title": "Quiz Title",
    "questions_attributes": [
      { "text": "Q1", "question_type": "mc", "options": ["A", "B"], "correct_answer": "A" }, ...
    ]
  }
}
```

### Response:
```
201 created
```

---

# 🎉 End of Documentation
