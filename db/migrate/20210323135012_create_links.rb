class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      t.belongs_to :question, foreign_ket: true

      t.timestamps
    end
  end
end
