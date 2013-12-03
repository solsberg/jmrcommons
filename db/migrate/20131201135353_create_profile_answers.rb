class CreateProfileAnswers < ActiveRecord::Migration
  def change
    create_table :profile_answers do |t|
      t.string :text
      t.integer :user_id
      t.integer :question_id

      t.timestamps
    end
  end
end
