/* global axios */

import ApiClient from './ApiClient';

class ResponseSourcesAPI extends ApiClient {
  constructor() {
    super('response_sources', { accountScoped: true });
  }

  listAllDocuments({ responseSourceId }) {
    return axios.get(`${this.url}/${responseSourceId}/list_all_documents`);
  }

  createDocument({ responseSourceId }) {
    return axios.get(`${this.url}/${responseSourceId}/create_document`);
  }

  parse({ link }) {
    return axios.post(`${this.url}/parse`, { link });
  }

  deleteDocument({ responseSourceId }) {
    return axios.get(`${this.url}/${responseSourceId}/create_document`);
  }
}

export default new ResponseSourcesAPI();
