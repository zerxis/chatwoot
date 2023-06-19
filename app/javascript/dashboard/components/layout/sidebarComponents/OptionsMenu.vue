<template>
  <transition name="menu-slide">
    <div
      v-if="show"
      v-on-clickaway="onClickAway"
      class="absolute left-3 bottom-16 bg-white dark:bg-slate-800 dark:border-slate-700 shadow-lg text-base border border-slate-50 rounded-lg p-2 min-w-[260px]"
    >
      <availability-status />
      <woot-dropdown-menu>
        <woot-dropdown-item v-if="showChangeAccountOption">
          <woot-button
            variant="clear"
            color-scheme="secondary"
            size="small"
            block
            icon="arrow-swap"
            @click="$emit('toggle-accounts')"
          >
            {{ $t('SIDEBAR_ITEMS.CHANGE_ACCOUNTS') }}
          </woot-button>
        </woot-dropdown-item>
        <woot-dropdown-item v-if="globalConfig.chatwootInboxToken">
          <woot-button
            variant="clear"
            color-scheme="secondary"
            size="small"
            block
            icon="chat-help"
            @click="$emit('show-support-chat-window')"
          >
            {{ $t('SIDEBAR_ITEMS.CONTACT_SUPPORT') }}
          </woot-button>
        </woot-dropdown-item>
        <woot-dropdown-item>
          <woot-button
            variant="clear"
            color-scheme="secondary"
            size="small"
            icon="keyboard"
            block
            @click="handleKeyboardHelpClick"
          >
            {{ $t('SIDEBAR_ITEMS.KEYBOARD_SHORTCUTS') }}
          </woot-button>
        </woot-dropdown-item>
        <woot-dropdown-item>
          <router-link
            v-slot="{ href, isActive, navigate }"
            :to="`/app/accounts/${accountId}/profile/settings`"
            custom
          >
            <a
              :href="href"
              class="text-xs font-medium text-slate-700 dark:text-slate-100 w-full p-2 hover:bg-slate-50 rounded hover:text-body flex items-center"
              :class="{ 'is-active': isActive }"
              @click="e => handleProfileSettingClick(e, navigate)"
            >
              <fluent-icon icon="person" size="14" class="min-w-[1rem]" />
              <span class="pl-2">
                {{ $t('SIDEBAR_ITEMS.PROFILE_SETTINGS') }}
              </span>
            </a>
          </router-link>
        </woot-dropdown-item>
        <woot-dropdown-item v-if="currentUser.type === 'SuperAdmin'">
          <a
            href="/super_admin"
            class="text-xs font-medium text-slate-700 dark:text-slate-100 w-full p-2 hover:bg-slate-50 rounded hover:text-body flex items-center"
            target="_blank"
            rel="noopener nofollow noreferrer"
            @click="$emit('close')"
          >
            <fluent-icon
              icon="content-settings"
              size="14"
              class="min-w-[1rem]"
            />
            <span class="pl-2">
              {{ $t('SIDEBAR_ITEMS.SUPER_ADMIN_CONSOLE') }}
            </span>
          </a>
        </woot-dropdown-item>
        <woot-dropdown-item>
          <woot-button
            variant="clear"
            color-scheme="secondary"
            size="small"
            block
            icon="power"
            @click="logout"
          >
            {{ $t('SIDEBAR_ITEMS.LOGOUT') }}
          </woot-button>
        </woot-dropdown-item>
      </woot-dropdown-menu>
    </div>
  </transition>
</template>

<script>
import { mixin as clickaway } from 'vue-clickaway';
import { mapGetters } from 'vuex';
import Auth from '../../../api/auth';
import WootDropdownItem from 'shared/components/ui/dropdown/DropdownItem';
import WootDropdownMenu from 'shared/components/ui/dropdown/DropdownMenu';
import AvailabilityStatus from 'dashboard/components/layout/AvailabilityStatus';

export default {
  components: {
    WootDropdownMenu,
    WootDropdownItem,
    AvailabilityStatus,
  },
  mixins: [clickaway],
  props: {
    show: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapGetters({
      currentUser: 'getCurrentUser',
      globalConfig: 'globalConfig/get',
      accountId: 'getCurrentAccountId',
    }),
    showChangeAccountOption() {
      if (this.globalConfig.createNewAccountFromDashboard) {
        return true;
      }

      const { accounts = [] } = this.currentUser;
      return accounts.length > 1;
    },
  },
  methods: {
    handleProfileSettingClick(e, navigate) {
      this.$emit('close');
      navigate(e);
    },
    handleKeyboardHelpClick() {
      this.$emit('key-shortcut-modal');
      this.$emit('close');
    },
    logout() {
      Auth.logout();
    },
    onClickAway() {
      if (this.show) this.$emit('close');
    },
  },
};
</script>
