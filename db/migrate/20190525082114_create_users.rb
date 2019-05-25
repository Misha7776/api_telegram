class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :telegram_id
      t.boolean :is_bot
      t.string :first_name
      t.string :last_name
      t.string :username
      t.jsonb :bot_command_data, default: {}

      t.timestamps
    end
  end
end
