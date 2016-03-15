class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :provider, :uid, :name, :refresh_token, :access_token
      t.timestamp :expires
      t.timestamps
    end
  end
end
