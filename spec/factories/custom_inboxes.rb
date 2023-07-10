# frozen_string_literal: true

FactoryBot.define do
  factory :custom_inbox do
    sequence(:name) { |n| "Custom inbox #{n}" }
    sequence(:description) { |n| "Custom inbox description #{n}" }
    icon { 'fluent:icon-add' }
    account
  end
end
