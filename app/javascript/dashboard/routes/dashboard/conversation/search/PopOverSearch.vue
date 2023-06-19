<template>
  <div class="flex py-2 px-4 items-center space-x-1">
    <woot-sidemenu-icon />
    <router-link
      :to="searchUrl"
      class="overflow-hidden flex items-center bg-slate-25 rounded-md px-2 py-1 h-6"
    >
      <fluent-icon icon="search" class="text-slate-600 mr-2" size="16" />
      <p
        class="text-ellipsis whitespace-nowrap overflow-hidden text-sm text-slate-600"
      >
        {{ $t('CONVERSATION.SEARCH_MESSAGES') }}
      </p>
    </router-link>
    <switch-layout
      :is-on-expanded-layout="isOnExpandedLayout"
      @toggle="$emit('toggle-conversation-layout')"
    />
  </div>
</template>

<script>
import { mixin as clickaway } from 'vue-clickaway';
import { mapGetters } from 'vuex';
import timeMixin from '../../../../mixins/time';
import messageFormatterMixin from 'shared/mixins/messageFormatterMixin';
import SwitchLayout from './SwitchLayout.vue';
import { frontendURL } from 'dashboard/helper/URLHelper';
export default {
  components: {
    SwitchLayout,
  },
  directives: {
    focus: {
      inserted(el) {
        el.focus();
      },
    },
  },
  mixins: [timeMixin, messageFormatterMixin, clickaway],
  props: {
    isOnExpandedLayout: {
      type: Boolean,
      required: true,
    },
  },

  data() {
    return {
      searchTerm: '',
    };
  },

  computed: {
    ...mapGetters({
      accountId: 'getCurrentAccountId',
    }),
    searchUrl() {
      return frontendURL(`accounts/${this.accountId}/search`);
    },
  },
};
</script>
