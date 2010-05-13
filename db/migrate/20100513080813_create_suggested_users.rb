class CreateSuggestedUsers < ActiveRecord::Migration
  def self.up
    create_table :suggested_users, :force => true do |t|
      t.string  :screen_name,       :limit => 32,  :null => false
      t.string  :name,              :limit => 32
      t.string  :profile_image_url, :limit => 128
      t.integer :followers_count
      t.string  :description,       :limit => 256
      t.string  :category,          :limit => 32

      t.timestamps
    end
    
    add_index :suggested_users, :screen_name
  end

  def self.down
    drop_table :suggested_users
  end
end
