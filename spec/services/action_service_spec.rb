require 'rails_helper'

describe ActionService do
  describe '#resolve_conversation' do
    let(:conversation) { create(:conversation) }
    let(:action_service) { described_class.new(conversation) }

    it 'resolves the conversation' do
      expect(conversation.status).to eq('open')
      action_service.resolve_conversation(nil)
      expect(conversation.reload.status).to eq('resolved')
    end
  end

  describe '#change_priority' do
    let(:conversation) { create(:conversation) }
    let(:action_service) { described_class.new(conversation) }

    it 'changes the priority of the conversation to medium' do
      action_service.change_priority(['medium'])
      expect(conversation.reload.priority).to eq('medium')
    end

    it 'changes the priority of the conversation to nil' do
      action_service.change_priority(['nil'])
      expect(conversation.reload.priority).to be_nil
    end
  end

  describe '#update_custom_inbox' do
    let(:conversation) { create(:conversation) }
    let(:custom_inbox) { create(:custom_inbox, account: conversation.account) }
    let(:action_service) { described_class.new(conversation) }

    it 'changes the custom_inbox_id' do
      action_service.update_custom_inbox(custom_inbox.id)
      expect(conversation.reload.custom_inbox_id).to eq(custom_inbox.id)
    end

    it 'removes custom inbox' do
      conversation.update!(custom_inbox_id: custom_inbox.id)
      action_service.update_custom_inbox(nil)
      expect(conversation.reload.custom_inbox_id).to be_nil
    end
  end

  # TODO: Expand this test suite
end
