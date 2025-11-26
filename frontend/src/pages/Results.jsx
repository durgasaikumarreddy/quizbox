import { useLocation, Link } from "react-router-dom";
import "../styles/results.css";

export default function Results() {
  const { state } = useLocation();
  if (!state) {
    return (
      <div className="no-results">
        <h2>No Results Found</h2>
        <p>Please take a quiz first to see your results.</p>
        <Link to="/">
          <button className="btn btn-primary">Back to Quizzes</button>
        </Link>
      </div>
    );
  }

  const percentage = Math.round((state.score / state.total) * 100);
  let badgeClass = "poor";
  if (percentage >= 80) badgeClass = "excellent";
  else if (percentage >= 60) badgeClass = "good";
  else if (percentage >= 40) badgeClass = "average";

  return (
    <div className="results-container">
      <div className="results-header">
        <h2>Quiz Results</h2>
      </div>

      <div className="score-display">
        <h3>Your Score</h3>
        <div className="score-number">{state.score}/{state.total}</div>
        <div className="score-percentage">{percentage}%</div>
        <span className={`score-badge ${badgeClass}`}>
          {badgeClass.charAt(0).toUpperCase() + badgeClass.slice(1)}
        </span>
      </div>

      <div className="results-list">
        <h3>Answer Review</h3>
        {state.results.map((r, i) => (
          <div key={i} className={`result-item ${r.correct ? "correct" : "incorrect"}`}>
            <div className="question-number">Question {i + 1}</div>
            <div className="question-text">{r.question_text || `Question ${i + 1}`}</div>
            <div className="answer-info">
              <div className="answer-row">
                <span className="answer-label">Your Answer:</span>
                <span className="user-answer">{r.user_answer || "No answer"}</span>
              </div>
              <div className="answer-row">
                <span className="answer-label">Correct Answer:</span>
                <span className="correct-answer">{r.correct_answer}</span>
              </div>
            </div>
            <div className={`status ${r.correct ? "correct" : "incorrect"}`}>
              <span className="status-icon">{r.correct ? "✓" : "✗"}</span>
              {r.correct ? "Correct" : "Incorrect"}
            </div>
          </div>
        ))}
      </div>

      <div className="results-actions">
        <Link to="/">
          <button className="btn btn-primary">Back to Quizzes</button>
        </Link>
      </div>
    </div>
  );
}
