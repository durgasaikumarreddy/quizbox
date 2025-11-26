import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import API from "../api/axios";
import "../styles/quiz-detail.css";

export default function QuizDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [quiz, setQuiz] = useState(null);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [answers, setAnswers] = useState({});
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    async function loadQuiz() {
      try {
        const res = await API.get(`/quizzes/${id}?page=${page}`);
        setQuiz({ id: res.data.id, title: res.data.title, questions: res.data.questions });
        setPage(parseInt(res.data.page || 1, 10));
        setTotalPages(parseInt(res.data.total_pages || 1, 10));
      } catch (err) {
        setError(err.response?.data?.error || "Error loading quiz");
      } finally {
        setLoading(false);
      }
    }
    loadQuiz();
  }, [id, page]);

  function prevPage() {
    if (page > 1) setPage(page - 1);
  }

  function nextPage() {
    if (page < totalPages) setPage(page + 1);
  }

  function updateAnswer(questionId, value) {
    setAnswers({ ...answers, [questionId]: value });
  }

  async function handleSubmit() {
    setSubmitting(true);
    setError("");
    try {
      const res = await API.post(`/quizzes/${id}/submit`, { answers });
      navigate("/results", { state: res.data });
    } catch (err) {
      setError(err.response?.data?.error || "Error submitting quiz");
    } finally {
      setSubmitting(false);
    }
  }

  if (loading) return <div className="loading-state"><span className="loading-spinner"></span>Loading quiz...</div>;
  if (error) return <div className="error-state"><h3>Error</h3>{error}</div>;
  if (!quiz) return <div className="error-state"><h3>Quiz not found</h3></div>;

  return (
    <div className="container">
      <h2>{quiz.title}</h2>
      
      {quiz.questions.map(q => (
        <div key={q.id} className="question-box">
          <p><strong>{q.text}</strong></p>

          {q.question_type === "mc" &&
            q.options.map((opt, i) => (
              <div key={i}>
                <input
                  type="radio"
                  name={`q-${q.id}`}
                  value={opt}
                  onChange={(e) => updateAnswer(q.id, e.target.value)}
                />
                {opt}
              </div>
            ))}

          {q.question_type === "tf" && (
            <>
              <input
                type="radio"
                name={`q-${q.id}`}
                value="true"
                onChange={(e) => updateAnswer(q.id, e.target.value)}
              /> True <br/>

              <input
                type="radio"
                name={`q-${q.id}`}
                value="false"
                onChange={(e) => updateAnswer(q.id, e.target.value)}
              /> False
            </>
          )}

          {q.question_type === "text" && (
            <input
              type="text"
              onChange={(e) => updateAnswer(q.id, e.target.value)}
            />
          )}
        </div>
      ))}

      <div style={{ marginTop: 20, display: "flex", justifyContent: "flex-end" }} className="questions-pagination">
        <button className="btn" onClick={prevPage} disabled={page <= 1}>Previous</button>
        <span style={{ margin: "0 12px", alignSelf: "center" }}>Page {page} / {totalPages}</span>
        <button className="btn" onClick={nextPage} disabled={page >= totalPages}>Next</button>
      </div>

      {page === totalPages && (
        <div style={{ marginTop: 18, marginLeft: 500, marginRight: 500, display: "flex", justifyContent: "flex-end" }}>
          <button onClick={handleSubmit} className="btn btn-primary" disabled={submitting}>{submitting ? "Submitting..." : "Submit"}</button>
        </div>
      )}
    </div>
  );
}
