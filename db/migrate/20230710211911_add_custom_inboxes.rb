class AddCustomInboxes < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_inboxes do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.references :account, index: true
      t.timestamps
    end

    add_reference :conversations, :custom_inbox, index: true, foreign_key: true
    add_index :conversations, [:custom_inbox_id, :account_id]
  end
end
