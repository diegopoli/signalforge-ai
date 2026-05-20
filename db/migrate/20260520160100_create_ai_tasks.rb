class CreateAiTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, foreign_key: true
      t.references :note, foreign_key: true
      t.string :task_type, null: false
      t.string :status, null: false, default: "queued"
      t.jsonb :input_payload, default: {}
      t.jsonb :output_payload, default: {}
      t.text :error_message

      t.timestamps
    end

    add_index :ai_tasks, [:user_id, :status]
  end
end
