import { useState } from "react";
import API from "../api/axios";
import "../styles/quiz.css";

export default function CreateQuiz() {
  const [title, setTitle] = useState("");
  const [questions, setQuestions] = useState([]);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [loading, setLoading] = useState(false);

  function addQuestion() {
    setQuestions([
      ...questions,
      { text: "", question_type: "mc", options: "", correct_answer: "" }
    ]);
  }

  function updateQuestion(index, field, value) {
    const updated = [...questions];
    updated[index][field] = value;
    setQuestions(updated);
  }

  function removeQuestion(index) {
    setQuestions(questions.filter((_, i) => i !== index));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError("");
    setSuccess("");
    setLoading(true);

    if (!title.trim()) {
      setError("Quiz title is required");
      setLoading(false);
      return;
    }

    if (questions.length === 0) {
      setError("At least one question is required");
      setLoading(false);
      return;
    }

    const formatted = questions.map(q => {
      let options = q.options ? q.options.split(",").map(s => s.trim()) : [];
      
      // For true/false questions, automatically set options
      if (q.question_type === "tf") {
        options = ["true", "false"];
      }

      if (q.question_type === "text") {
        options = [q.correct_answer];
      }

      return {
        ...q,
        options: options
      };
    });

    const payload = { quiz: { title, questions_attributes: formatted } };

    try {
      await API.post("/quizzes", payload);
      setSuccess("Quiz created successfully!");
      setTimeout(() => {
        window.location.href = "/";
      }, 1500);
    } catch (err) {
      const message = err.response?.data?.errors?.join(", ") || "Error creating quiz";
      setError(message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="create-quiz-container">
      <h2>Create Quiz</h2>

      {error && <div className="alert alert-error">{error}</div>}
      {success && <div className="alert alert-success">{success}</div>}

      <form className="quiz-form" onSubmit={handleSubmit}>
        <div className="form-group">
          <label>Quiz Title *</label>
          <input
            type="text"
            placeholder="Enter quiz title"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            required
          />
        </div>

        <div className="questions-section">
          {questions.length > 0 && <h3>Questions ({questions.length})</h3>}
          {questions.map((q, i) => (
            <div className="question-item" key={i}>
              <h4>Question {i + 1}</h4>

              <div className="form-group">
                <label>Question Text *</label>
                <input
                  type="text"
                  placeholder="Enter question text"
                  value={q.text}
                  onChange={(e) => updateQuestion(i, "text", e.target.value)}
                  required
                />
              </div>

              <div className="form-group">
                <label>Question Type *</label>
                <select
                  value={q.question_type}
                  onChange={(e) => updateQuestion(i, "question_type", e.target.value)}
                >
                  <option value="mc">Multiple Choice</option>
                  <option value="tf">True / False</option>
                  <option value="text">Short Answer</option>
                </select>
              </div>

              {q.question_type === "mc" && (
                <div className="form-group">
                  <label>Options (comma separated) *</label>
                  <input
                    type="text"
                    placeholder="e.g., Option A, Option B, Option C"
                    value={q.options}
                    onChange={(e) => updateQuestion(i, "options", e.target.value)}
                    required
                  />
                </div>
              )}

              <div className="form-group">
                <label>Correct Answer *</label>
                <input
                  type="text"
                  placeholder="Enter the correct answer"
                  value={q.correct_answer}
                  onChange={(e) => updateQuestion(i, "correct_answer", e.target.value)}
                  required
                />
              </div>

              <button 
                type="button" 
                className="btn btn-small btn-danger"
                onClick={() => removeQuestion(i)}
              >
                Remove Question
              </button>
            </div>
          ))}
        </div>
        
        <button type="button" className="add-question-btn" onClick={addQuestion}>
          + Add Question
        </button>

        <div className="button-group">
          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? "Creating quiz..." : "Create Quiz"}
          </button>
        </div>
      </form>
    </div>
  );
}
