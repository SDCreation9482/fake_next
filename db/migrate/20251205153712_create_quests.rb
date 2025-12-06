class CreateQuests < ActiveRecord::Migration[7.0]
  def change
    create_table :quests do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :status, null: false, default: "drafted"
      t.references :user, null: false, foreign_key: true
      t.text :metadata
      t.datetime :published_at

      t.timestamps
    end

    add_index :quests, :slug, unique: true
  end
end
