import { BrowserRouter, Routes, Route } from "react-router-dom";
import AdminLogin from "./pages/AdminLogin";
import CreateQuiz from "./pages/CreateQuiz";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/admin/login" element={<AdminLogin />} />
        <Route path="/quizzes/create" element={<CreateQuiz />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
