class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.column :embedding, :vector, limit: 1536
      t.string :status, null: false, default: "ready"
      t.string :source_type, null: false, default: "advisor_doc"

      t.timestamps
    end

    add_index :documents, :status
  end
end
