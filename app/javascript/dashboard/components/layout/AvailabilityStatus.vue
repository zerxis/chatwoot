<template>
  <woot-dropdown-menu>
    <woot-dropdown-header :title="$t('SIDEBAR.SET_AVAILABILITY_TITLE')" />
    <woot-dropdown-item
      v-for="status in availabilityStatuses"
      :key="status.value"
    >
      <woot-button
        size="small"
        block
        :color-scheme="status.disabled ? 'primary' : 'secondary'"
        :variant="status.disabled ? 'smooth' : 'clear'"
        @click="changeAvailabilityStatus(status.value)"
      >
        <availability-status-badge :status="status.value" />
        <span class="pl-2">{{ status.label }}</span>
      </woot-button>
    </woot-dropdown-item>
    <woot-dropdown-divider />
    <woot-dropdown-item class="text-xs flex items-center justify-between p-2">
      <div class="flex items-center text-slate-700 dark:text-slate-100">
        <fluent-icon
          v-tooltip.right-start="$t('SIDEBAR.SET_AUTO_OFFLINE.INFO_TEXT')"
          icon="info"
          size="14"
          class="min-w-[1rem]"
        />

        <div class="mr-1 ml-2 font-medium">
          {{ $t('SIDEBAR.SET_AUTO_OFFLINE.TEXT') }}
        </div>
      </div>

      <woot-switch
        size="small"
        :value="currentUserAutoOffline"
        @input="updateAutoOffline"
      />
    </woot-dropdown-item>
    <woot-dropdown-divider />
  </woot-dropdown-menu>
</template>

<script>
import { mapGetters } from 'vuex';
import { mixin as clickaway } from 'vue-clickaway';
import alertMixin from 'shared/mixins/alertMixin';
import WootDropdownItem from 'shared/components/ui/dropdown/DropdownItem';
import WootDropdownMenu from 'shared/components/ui/dropdown/DropdownMenu';
import WootDropdownHeader from 'shared/components/ui/dropdown/DropdownHeader';
import WootDropdownDivider from 'shared/components/ui/dropdown/DropdownDivider';
import AvailabilityStatusBadge from '../widgets/conversation/AvailabilityStatusBadge';
import wootConstants from 'dashboard/constants/globals';

const { AVAILABILITY_STATUS_KEYS } = wootConstants;

export default {
  components: {
    WootDropdownHeader,
    WootDropdownDivider,
    WootDropdownMenu,
    WootDropdownItem,
    AvailabilityStatusBadge,
  },

  mixins: [clickaway, alertMixin],

  data() {
    return {
      isStatusMenuOpened: false,
      isUpdating: false,
    };
  },

  computed: {
    ...mapGetters({
      getCurrentUserAvailability: 'getCurrentUserAvailability',
      currentAccountId: 'getCurrentAccountId',
      currentUserAutoOffline: 'getCurrentUserAutoOffline',
    }),
    availabilityDisplayLabel() {
      const availabilityIndex = AVAILABILITY_STATUS_KEYS.findIndex(
        key => key === this.currentUserAvailability
      );
      return this.$t('PROFILE_SETTINGS.FORM.AVAILABILITY.STATUSES_LIST')[
        availabilityIndex
      ];
    },
    currentUserAvailability() {
      return this.getCurrentUserAvailability;
    },
    availabilityStatuses() {
      return this.$t('PROFILE_SETTINGS.FORM.AVAILABILITY.STATUSES_LIST').map(
        (statusLabel, index) => ({
          label: statusLabel,
          value: AVAILABILITY_STATUS_KEYS[index],
          disabled:
            this.currentUserAvailability === AVAILABILITY_STATUS_KEYS[index],
        })
      );
    },
  },

  methods: {
    openStatusMenu() {
      this.isStatusMenuOpened = true;
    },
    closeStatusMenu() {
      this.isStatusMenuOpened = false;
    },
    updateAutoOffline(autoOffline) {
      this.$store.dispatch('updateAutoOffline', {
        accountId: this.currentAccountId,
        autoOffline,
      });
    },
    changeAvailabilityStatus(availability) {
      if (this.isUpdating) {
        return;
      }

      this.isUpdating = true;
      try {
        this.$store.dispatch('updateAvailability', {
          availability,
          account_id: this.currentAccountId,
        });
      } catch (error) {
        this.showAlert(
          this.$t('PROFILE_SETTINGS.FORM.AVAILABILITY.SET_AVAILABILITY_ERROR')
        );
      } finally {
        this.isUpdating = false;
      }
    },
  },
};
</script>
