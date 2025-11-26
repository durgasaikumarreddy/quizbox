import { BrowserRouter, Routes, Route } from "react-router-dom";
import AdminLogin from "./pages/AdminLogin";
import CreateQuiz from "./pages/CreateQuiz";
import QuizList from "./pages/QuizList";
import QuizDetail from "./pages/QuizDetail";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/admin/login" element={<AdminLogin />} />
        <Route path="/quizzes/create" element={<CreateQuiz />} />
        <Route path="/" element={<QuizList />} />
        <Route path="/quizzes/:id" element={<QuizDetail />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
