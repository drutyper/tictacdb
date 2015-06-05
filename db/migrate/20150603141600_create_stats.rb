class CreateStats < ActiveRecord::Migration
  def change
    create_table "stats" do |t|
      t.integer "user_id"
      t.boolean "won"
      t.datetime "played_on"
    end
  end
end
