/* global axios */
import ApiClient from './ApiClient';

class CustomInboxesAPI extends ApiClient {
  constructor() {
    super('custom_inboxes', { accountScoped: true });
  }

  addConversationToInbox(customInboxId, conversationId) {
    return axios.post(`${this.url}/add_conversation_to_custom_inbox`, {
      id: customInboxId,
      conversation_id: conversationId,
    });
  }
}

export default new CustomInboxesAPI();
