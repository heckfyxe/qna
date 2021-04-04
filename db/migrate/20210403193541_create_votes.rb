class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true, index: true
      t.references :votable, polymorphic: true, index: true
      t.integer :value

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
