class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.references :commentable, polymorphic: true
      t.references :author, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
