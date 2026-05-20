class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :risk_profile
      t.string :lifecycle_stage, default: "active", null: false
      t.text :profile_notes

      t.timestamps
    end

    add_index :clients, [:user_id, :email]
  end
end
