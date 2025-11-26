class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.string :text
      t.string :question_type
      t.jsonb :options
      t.string :correct_answer

      t.timestamps
    end
  end
end
