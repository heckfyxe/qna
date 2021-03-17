class AddTheBestToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :the_best, :boolean, default: false
  end
end
