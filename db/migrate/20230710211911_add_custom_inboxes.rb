class AddCustomInboxes < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_inboxes do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.references :account, index: true
      t.timestamps
    end

    add_column :conversations, :custom_inboxes_id, :integer
    add_index :conversations, [:custom_inboxes_id, :account_id]
  end
end
