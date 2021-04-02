class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
      t.string :oidc_identifier, null: false, default: "", unique: true
      t.string :oidc_access_token, null: false, default: ""
      t.string :oidc_refresh_token, null: false, default: ""
      t.timestamps
    end
  end
end
