class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys, id: false do |t|
      t.string :label
      t.string :access_key, index: true, unique: true
      t.string :secret_key, unique: true
      t.references :user
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
