class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :title
      t.string :source_type, null: false, default: "meeting_note"
      t.text :raw_content, null: false
      t.text :summary
      t.text :action_items
      t.text :email_draft
      t.string :processing_status, null: false, default: "pending"

      t.timestamps
    end

    add_index :notes, [:client_id, :created_at]
    add_index :notes, :processing_status
  end
end
