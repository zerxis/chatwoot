<template>
  <div class="flex p-3 border-b border-slate-50">
    <back-button v-if="showBackButton" :back-url="backButtonUrl" />
    <thumbnail
      :src="currentContact.thumbnail"
      :badge="inboxBadge"
      :username="currentContact.name"
      :status="currentContact.availability_status"
    />
    <div class="flex flex-col min-w-[240px] ml-3 shrink-0">
      <woot-button
        variant="link"
        color-scheme="secondary"
        class="text-left"
        @click.prevent="$emit('contact-panel-toggle')"
      >
        <h3 class="text-base font-medium truncate flex items-center">
          <span>{{ currentContact.name }}</span>
          <fluent-icon
            v-if="!isHMACVerified"
            v-tooltip="$t('CONVERSATION.UNVERIFIED_SESSION')"
            size="14"
            class="ml-2 text-yellow-600"
            icon="warning"
          />
        </h3>
      </woot-button>
      <div class="flex">
        <inbox-name v-if="hasMultipleInboxes" :inbox="inbox" />
        <span v-if="isSnoozed" class="snoozed--display-text">
          {{ snoozedDisplayText }}
        </span>
        <woot-button
          class="text-xs text-link ml-2"
          size="small"
          variant="link"
          @click="$emit('contact-panel-toggle')"
        >
          {{ contactPanelToggleText }}
        </woot-button>
      </div>
    </div>
    <more-actions :conversation-id="currentChat.id" />
  </div>
</template>
<script>
import { hasPressedAltAndOKey } from 'shared/helpers/KeyboardHelpers';
import { mapGetters } from 'vuex';
import agentMixin from '../../../mixins/agentMixin.js';
import BackButton from '../BackButton';
import eventListenerMixins from 'shared/mixins/eventListenerMixins';
import inboxMixin from 'shared/mixins/inboxMixin';
import InboxName from '../InboxName';
import MoreActions from './MoreActions';
import Thumbnail from '../Thumbnail';
import wootConstants from 'dashboard/constants/globals';
import { conversationListPageURL } from 'dashboard/helper/URLHelper';
import { conversationReopenTime } from 'dashboard/helper/snoozeHelpers';

export default {
  components: {
    BackButton,
    InboxName,
    MoreActions,
    Thumbnail,
  },
  mixins: [inboxMixin, agentMixin, eventListenerMixins],
  props: {
    chat: {
      type: Object,
      default: () => {},
    },
    isContactPanelOpen: {
      type: Boolean,
      default: false,
    },
    showBackButton: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapGetters({
      uiFlags: 'inboxAssignableAgents/getUIFlags',
      currentChat: 'getSelectedChat',
    }),
    chatMetadata() {
      return this.chat.meta;
    },
    backButtonUrl() {
      const {
        params: { accountId, inbox_id: inboxId, label, teamId },
        name,
      } = this.$route;
      return conversationListPageURL({
        accountId,
        inboxId,
        label,
        teamId,
        conversationType: name === 'conversation_mentions' ? 'mention' : '',
      });
    },
    isHMACVerified() {
      if (!this.isAWebWidgetInbox) {
        return true;
      }
      return this.chatMetadata.hmac_verified;
    },
    currentContact() {
      return this.$store.getters['contacts/getContact'](
        this.chat.meta.sender.id
      );
    },
    isSnoozed() {
      return this.currentChat.status === wootConstants.STATUS_TYPE.SNOOZED;
    },
    snoozedDisplayText() {
      const { snoozed_until: snoozedUntil } = this.currentChat;
      if (snoozedUntil) {
        return `${this.$t(
          'CONVERSATION.HEADER.SNOOZED_UNTIL'
        )} ${conversationReopenTime(snoozedUntil)}`;
      }
      return this.$t('CONVERSATION.HEADER.SNOOZED_UNTIL_NEXT_REPLY');
    },
    contactPanelToggleText() {
      return `${
        this.isContactPanelOpen
          ? this.$t('CONVERSATION.HEADER.CLOSE')
          : this.$t('CONVERSATION.HEADER.OPEN')
      } ${this.$t('CONVERSATION.HEADER.DETAILS')}`;
    },
    inbox() {
      const { inbox_id: inboxId } = this.chat;
      return this.$store.getters['inboxes/getInbox'](inboxId);
    },
    hasMultipleInboxes() {
      return this.$store.getters['inboxes/getInboxes'].length > 1;
    },
  },

  methods: {
    handleKeyEvents(e) {
      if (hasPressedAltAndOKey(e)) {
        this.$emit('contact-panel-toggle');
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.conversation-header--details {
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
  width: 100%;

  // @include breakpoint(medium up) {
  //   flex-direction: row;
  // }
}

.option__desc {
  display: flex;
  align-items: center;
}

.option__desc {
  &::v-deep .status-badge {
    margin-right: var(--space-small);
    min-width: 0;
    flex-shrink: 0;
  }
}

.user--name {
  display: inline-block;
  line-height: 1.2;
  text-transform: capitalize;
  margin: 0;
  padding: 0;
}

.conversation--header--actions {
  align-items: center;
  display: flex;
  font-size: var(--font-size-mini);
  gap: var(--space-small);

  ::v-deep .inbox--name {
    margin: 0;
  }

  .user--profile__button {
    padding: 0;
  }

  .snoozed--display-text {
    font-weight: var(--font-weight-medium);
    color: var(--y-600);
  }
}
</style>
