<template>
  <div
    class="flex max-w-full grow border-l-2 first:-mt-px border-transparent cursor-pointer px-4 relative items-start hover:bg-slate-25 overflow-hidden"
    :class="{
      active: isActiveChat,
      'unread-chat': hasUnread,

      'conversation-selected': selected,
    }"
    @mouseenter="onCardHover"
    @mouseleave="onCardLeave"
    @click="onCardClick"
    @contextmenu="openContextMenu($event)"
  >
    <div :class="{ 'mt-8': showInboxName }">
      <div
        v-if="hovered || selected"
        class="h-10 min-w-[2.5rem] w-10 flex rounded-full cursor-pointer items-center justify-center hover:bg-woot-100"
        @click.stop
      >
        <input
          :value="selected"
          :checked="selected"
          class="mt-0 cursor-pointer"
          type="checkbox"
          @change="onSelectConversation($event.target.checked)"
        />
      </div>
      <thumbnail
        v-if="bulkActionCheck"
        :src="currentContact.thumbnail"
        :badge="inboxBadge"
        :username="currentContact.name"
        :status="currentContact.availability_status"
        size="40px"
      />
    </div>
    <div
      class="py-3 flex flex-col grow ml-3 border-t border-slate-50 w-auto overflow-hidden"
    >
      <div class="flex items-center justify-between grow">
        <inbox-name v-if="showInboxName" :inbox="inbox" />
        <div class="flex items-center grow justify-end space-x-2">
          <span
            v-if="showAssignee && assignee.name"
            class="text-xs inline-flex font-medium text-slate-500 items-center max-w-full truncate"
          >
            <fluent-icon icon="person" size="12" />
            {{ assignee.name }}
          </span>
          <priority-mark :priority="chat.priority" />
        </div>
      </div>
      <div class="flex items-center justify-between">
        <h4
          class="text-sm pt-0.5 font-medium text-ellipsis overflow-hidden w-3/5 whitespace-nowrap"
        >
          {{ currentContact.name }}
        </h4>
        <time-ago
          :last-activity-timestamp="chat.timestamp"
          :created-at-timestamp="chat.created_at"
        />
      </div>
      <div
        class="flex items-center justify-between flex-1 overflow-hidden w-auto"
      >
        <fluent-icon
          v-if="isMessagePrivate"
          class="mr-1 shrink-0"
          size="16"
          icon="lock-closed"
        />
        <fluent-icon
          v-else-if="messageByAgent"
          size="16"
          class="mr-1 shrink-0"
          icon="arrow-reply"
        />
        <fluent-icon
          v-else-if="isMessageAnActivity"
          class="mr-1 shrink-0"
          size="16"
          icon="info"
        />
        <fluent-icon
          v-else-if="attachmentIcon"
          size="16"
          :icon="attachmentIcon"
        />
        <p
          v-if="lastMessageInChat"
          class="text-sm flex items-center leading-6 max-w-full flex-1 overflow-hidden"
        >
          <span v-if="lastMessageInChat.content" class="truncate">
            {{ parsedLastMessage }}
          </span>
          <span v-else-if="lastMessageInChat.attachments">
            {{ this.$t(`${attachmentMessageContent}`) }}
          </span>
          <span v-else>
            {{ $t('CHAT_LIST.NO_CONTENT') }}
          </span>
        </p>
        <p v-else class="conversation--message">
          <fluent-icon size="16" class="message--attachment-icon" icon="info" />
          <span>
            {{ this.$t(`CHAT_LIST.NO_MESSAGES`) }}
          </span>
        </p>
        <span
          v-if="unreadCount"
          class="shrink-0 ml-2 text-white bg-green-400 h-4 w-4 min-w-[1rem] rounded-full text-xxs flex items-center justify-center font-medium"
        >
          {{ unreadCount > 9 ? '9+' : unreadCount }}
        </span>
      </div>
      <card-labels :conversation-id="chat.id" />
    </div>
    <woot-context-menu
      v-if="showContextMenu"
      ref="menu"
      :x="contextMenu.x"
      :y="contextMenu.y"
      @close="closeContextMenu"
    >
      <conversation-context-menu
        :status="chat.status"
        :inbox-id="inbox.id"
        :priority="chat.priority"
        :has-unread-messages="hasUnread"
        @update-conversation="onUpdateConversation"
        @assign-agent="onAssignAgent"
        @assign-label="onAssignLabel"
        @assign-team="onAssignTeam"
        @mark-as-unread="markAsUnread"
        @assign-priority="assignPriority"
      />
    </woot-context-menu>
  </div>
</template>
<script>
import { mapGetters } from 'vuex';
import { MESSAGE_TYPE } from 'widget/helpers/constants';
import messageFormatterMixin from 'shared/mixins/messageFormatterMixin';
import Thumbnail from '../Thumbnail';
import conversationMixin from '../../../mixins/conversations';
import timeMixin from '../../../mixins/time';
import router from '../../../routes';
import { frontendURL, conversationUrl } from '../../../helper/URLHelper';
import InboxName from '../InboxName';
import inboxMixin from 'shared/mixins/inboxMixin';
import ConversationContextMenu from './contextMenu/Index.vue';
import alertMixin from 'shared/mixins/alertMixin';
import TimeAgo from 'dashboard/components/ui/TimeAgo';
import CardLabels from './conversationCardComponents/CardLabels.vue';
import PriorityMark from './PriorityMark.vue';
const ATTACHMENT_ICONS = {
  image: 'image',
  audio: 'headphones-sound-wave',
  video: 'video',
  file: 'document',
  location: 'location',
  fallback: 'link',
};

export default {
  components: {
    CardLabels,
    InboxName,
    Thumbnail,
    ConversationContextMenu,
    TimeAgo,
    PriorityMark,
  },

  mixins: [
    inboxMixin,
    timeMixin,
    conversationMixin,
    messageFormatterMixin,
    alertMixin,
  ],
  props: {
    activeLabel: {
      type: String,
      default: '',
    },
    chat: {
      type: Object,
      default: () => {},
    },
    hideInboxName: {
      type: Boolean,
      default: false,
    },
    hideThumbnail: {
      type: Boolean,
      default: false,
    },
    teamId: {
      type: [String, Number],
      default: 0,
    },
    foldersId: {
      type: [String, Number],
      default: 0,
    },
    showAssignee: {
      type: Boolean,
      default: false,
    },
    conversationType: {
      type: String,
      default: '',
    },
    selected: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      hovered: false,
      showContextMenu: false,
      contextMenu: {
        x: null,
        y: null,
      },
    };
  },
  computed: {
    ...mapGetters({
      currentChat: 'getSelectedChat',
      inboxesList: 'inboxes/getInboxes',
      activeInbox: 'getSelectedInbox',
      currentUser: 'getCurrentUser',
      accountId: 'getCurrentAccountId',
    }),
    bulkActionCheck() {
      return !this.hideThumbnail && !this.hovered && !this.selected;
    },
    chatMetadata() {
      return this.chat.meta || {};
    },

    assignee() {
      return this.chatMetadata.assignee || {};
    },

    currentContact() {
      return this.$store.getters['contacts/getContact'](
        this.chatMetadata.sender.id
      );
    },

    lastMessageFileType() {
      const lastMessage = this.lastMessageInChat;
      const [{ file_type: fileType } = {}] = lastMessage.attachments;
      return fileType;
    },

    attachmentIcon() {
      return ATTACHMENT_ICONS[this.lastMessageFileType];
    },

    attachmentMessageContent() {
      return `CHAT_LIST.ATTACHMENTS.${this.lastMessageFileType}.CONTENT`;
    },

    isActiveChat() {
      return this.currentChat.id === this.chat.id;
    },

    unreadCount() {
      return this.chat.unread_count;
    },

    hasUnread() {
      return this.unreadCount > 0;
    },

    isInboxNameVisible() {
      return !this.activeInbox;
    },

    lastMessageInChat() {
      return this.lastMessage(this.chat);
    },

    messageByAgent() {
      const lastMessage = this.lastMessageInChat;
      const { message_type: messageType } = lastMessage;
      return messageType === MESSAGE_TYPE.OUTGOING;
    },

    isMessageAnActivity() {
      const lastMessage = this.lastMessageInChat;
      const { message_type: messageType } = lastMessage;
      return messageType === MESSAGE_TYPE.ACTIVITY;
    },

    isMessagePrivate() {
      const lastMessage = this.lastMessageInChat;
      const { private: isPrivate } = lastMessage;
      return isPrivate;
    },

    parsedLastMessage() {
      const { content_attributes: contentAttributes } = this.lastMessageInChat;
      const { email: { subject } = {} } = contentAttributes || {};
      return this.getPlainText(subject || this.lastMessageInChat.content);
    },

    inbox() {
      const { inbox_id: inboxId } = this.chat;
      const stateInbox = this.$store.getters['inboxes/getInbox'](inboxId);
      return stateInbox;
    },

    showInboxName() {
      return (
        !this.hideInboxName &&
        this.isInboxNameVisible &&
        this.inboxesList.length > 1
      );
    },
    inboxName() {
      const stateInbox = this.inbox;
      return stateInbox.name || '';
    },
  },
  methods: {
    onCardClick(e) {
      const { activeInbox, chat } = this;
      const path = frontendURL(
        conversationUrl({
          accountId: this.accountId,
          activeInbox,
          id: chat.id,
          label: this.activeLabel,
          teamId: this.teamId,
          foldersId: this.foldersId,
          conversationType: this.conversationType,
        })
      );

      if (e.metaKey || e.ctrlKey) {
        window.open(
          window.chatwootConfig.hostURL + path,
          '_blank',
          'noopener noreferrer nofollow'
        );
        return;
      }
      if (this.isActiveChat) {
        return;
      }

      router.push({ path });
    },
    onCardHover() {
      this.hovered = !this.hideThumbnail;
    },
    onCardLeave() {
      this.hovered = false;
    },
    onSelectConversation(checked) {
      const action = checked ? 'select-conversation' : 'de-select-conversation';
      this.$emit(action, this.chat.id, this.inbox.id);
    },
    openContextMenu(e) {
      e.preventDefault();
      this.$emit('context-menu-toggle', true);
      this.contextMenu.x = e.pageX || e.clientX;
      this.contextMenu.y = e.pageY || e.clientY;
      this.showContextMenu = true;
    },
    closeContextMenu() {
      this.$emit('context-menu-toggle', false);
      this.showContextMenu = false;
      this.contextMenu.x = null;
      this.contextMenu.y = null;
    },
    onUpdateConversation(status, snoozedUntil) {
      this.closeContextMenu();
      this.$emit(
        'update-conversation-status',
        this.chat.id,
        status,
        snoozedUntil
      );
    },
    async onAssignAgent(agent) {
      this.$emit('assign-agent', agent, [this.chat.id]);
      this.closeContextMenu();
    },
    async onAssignLabel(label) {
      this.$emit('assign-label', [label.title], [this.chat.id]);
      this.closeContextMenu();
    },
    async onAssignTeam(team) {
      this.$emit('assign-team', team, this.chat.id);
      this.closeContextMenu();
    },
    async markAsUnread() {
      this.$emit('mark-as-unread', this.chat.id);
      this.closeContextMenu();
    },
    async assignPriority(priority) {
      this.$emit('assign-priority', priority, this.chat.id);
      this.closeContextMenu();
    },
  },
};
</script>
