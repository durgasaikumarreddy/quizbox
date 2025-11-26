import { useEffect, useState } from "react";
import API from "../api/axios";
import { Link } from "react-router-dom";
import "../styles/quiz-list.css";

export default function QuizList() {
  const [quizzes, setQuizzes] = useState([]);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function load(pageNum = 1) {
    setError("");
    setLoading(true);
    try {
      const res = await API.get(`/quizzes?page=${pageNum}`);
      setQuizzes(res.data.quizzes);
      setPage(res.data.page);
      setTotalPages(res.data.total_pages);
    } catch (err) {
      const message = err.response?.data?.error || "Error loading quizzes";
      setError(message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load(1);
  }, []);

  return (
    <div className="quiz-list-container">
      <h1>Available Quizzes</h1>
      
      {error && <div className="alert alert-error">{error}</div>}
      
      {loading && <div className="loading">Loading quizzes...</div>}
      
      {!loading && quizzes.length === 0 && !error && (
        <div className="empty-state">
          <h2>No quizzes available</h2>
          <p>Check back later for new quizzes!</p>
        </div>
      )}

      {!loading && quizzes.length > 0 && (
        <>
          <div className="quiz-grid">
            {quizzes.map(q => (
              <Link key={q.id} to={`/quizzes/${q.id}`} className="quiz-card">
                <h3>{q.title}</h3>
                <p>Click to start quiz</p>
              </Link>
            ))}
          </div>

          <div className="pagination-container">
            <button 
              className="pagination-btn"
              disabled={page <= 1} 
              onClick={() => load(page - 1)}
            >
              ← Previous
            </button>
            <span>{page} / {totalPages}</span>
            <button 
              className="pagination-btn"
              disabled={page >= totalPages} 
              onClick={() => load(page + 1)}
            >
              Next →
            </button>
          </div>
        </>
      )}
    </div>
  );
}
