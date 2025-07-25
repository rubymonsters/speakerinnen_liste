class CreateOffensiveTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :offensive_terms do |t|
      t.string :word

      t.timestamps
    end
  end
end
