import * as MutationHelpers from 'shared/helpers/vuex/mutationHelpers';
import types from '../mutation-types';
import ResponseSourcesAPI from '../../api/responseSources';
import { throwErrorMessage } from '../utils/api';

export const state = {
  records: [],
  uiFlags: {
    isFetchingItem: false,
    isFetching: false,
    isCreating: false,
    isDeleting: false,
    isUpdating: false,
    isParsing: false,
  },
  parsedLinks: [],
};

export const getters = {
  getResponseSources($state) {
    return $state.records;
  },
  getResponseSource: $state => id => {
    return $state.records.find(record => record.id === Number(id));
  },
  getParsedLinks: $state => $state.parsedLinks,
  getUIFlags($state) {
    return $state.uiFlags;
  },
};

export const actions = {
  get: async function getResponseSources({ commit }) {
    commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isFetching: true });
    try {
      const response = await ResponseSourcesAPI.get();
      commit(types.SET_RESPONSE_SOURCES, response.data);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isFetching: false });
    }
  },
  getSingleMacro: async function getResponseSourcesById({ commit }, macroId) {
    commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isFetchingItem: true });
    try {
      const response = await ResponseSourcesAPI.show(macroId);
      commit(types.ADD_RESPONSE_SOURCE, response.data.payload);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isFetchingItem: false });
    }
  },
  create: async function createResponseSource(
    { commit },
    responseSourceObject
  ) {
    commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isCreating: true });
    try {
      const response = await ResponseSourcesAPI.create(responseSourceObject);
      commit(types.ADD_RESPONSE_SOURCE, response.data);
      return response.data;
    } catch (error) {
      throwErrorMessage(error);
    } finally {
      commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isCreating: false });
    }
    return null;
  },
  parse: async function parseResponseSource({ commit }, { link }) {
    commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isParsing: true });
    commit(types.SET_RESPONSE_SOURCE_PARSED_LINKS, []);
    try {
      const response = await ResponseSourcesAPI.parse({ link });
      commit(types.SET_RESPONSE_SOURCE_PARSED_LINKS, response.data.links);
    } catch (error) {
      throwErrorMessage(error);
    } finally {
      commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isParsing: false });
    }
  },
  update: async ({ commit }, { id, ...updateObj }) => {
    commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isUpdating: true });
    try {
      const response = await ResponseSourcesAPI.update(id, updateObj);
      commit(types.EDIT_MACRO, response.data.payload);
    } catch (error) {
      throwErrorMessage(error);
    } finally {
      commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isUpdating: false });
    }
  },
  delete: async ({ commit }, id) => {
    commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isDeleting: true });
    try {
      await ResponseSourcesAPI.delete(id);
      commit(types.DELETE_MACRO, id);
    } catch (error) {
      throwErrorMessage(error);
    } finally {
      commit(types.SET_RESPONSE_SOURCE_UI_FLAGS, { isDeleting: false });
    }
  },
};

export const mutations = {
  [types.SET_RESPONSE_SOURCE_UI_FLAGS]($state, data) {
    $state.uiFlags = {
      ...$state.uiFlags,
      ...data,
    };
  },
  [types.SET_RESPONSE_SOURCE_PARSED_LINKS]($state, links = []) {
    $state.parsedLinks = links;
  },
  [types.ADD_RESPONSE_SOURCE]: MutationHelpers.setSingleRecord,
  [types.SET_RESPONSE_SOURCES]: MutationHelpers.set,
  [types.EDIT_MACRO]: MutationHelpers.update,
  [types.DELETE_MACRO]: MutationHelpers.destroy,
};

export default {
  namespaced: true,
  actions,
  state,
  getters,
  mutations,
};
