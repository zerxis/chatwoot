# == Schema Information
#
# Table name: custom_inboxes
#
#  id          :bigint           not null, primary key
#  description :text
#  icon        :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#
# Indexes
#
#  index_custom_inboxes_on_account_id  (account_id)
#
class CustomInbox < ApplicationRecord
  belongs_to :account
end
