<template>
  <div class="flex justify-between bg-slate-50 pr-3">
    <div class="button-group flex items-center">
      <button
        :class="replyButtonClass"
        class="px-3 py-2 border-r border-slate-100 text-sm font-medium text-woot-500"
        @click="handleReplyClick"
      >
        {{ $t('CONVERSATION.REPLYBOX.REPLY') }}
      </button>

      <button
        :class="noteButtonClass"
        class="px-3 py-2 border-r border-slate-100 text-sm font-medium text-yellow-600"
        @click="handleNoteClick"
      >
        {{ $t('CONVERSATION.REPLYBOX.PRIVATE_NOTE') }}
      </button>
    </div>
    <div class="action-wrap">
      <div v-if="isMessageLengthReachingThreshold" class="tabs-title">
        <span :class="charLengthClass">
          {{ characterLengthWarning }}
        </span>
      </div>
    </div>
    <woot-button
      v-if="popoutReplyBox"
      variant="clear"
      icon="dismiss"
      color-scheme="secondary"
      class-names="popout-button"
      @click="$emit('click')"
    />
    <woot-button
      v-else
      variant="clear"
      icon="resize-large"
      color-scheme="secondary"
      class-names="popout-button"
      @click="$emit('click')"
    />
  </div>
</template>

<script>
import { REPLY_EDITOR_MODES, CHAR_LENGTH_WARNING } from './constants';
import {
  hasPressedAltAndPKey,
  hasPressedAltAndLKey,
} from 'shared/helpers/KeyboardHelpers';
import eventListenerMixins from 'shared/mixins/eventListenerMixins';
export default {
  name: 'ReplyTopPanel',
  mixins: [eventListenerMixins],
  props: {
    mode: {
      type: String,
      default: REPLY_EDITOR_MODES.REPLY,
    },
    setReplyMode: {
      type: Function,
      default: () => {},
    },
    isMessageLengthReachingThreshold: {
      type: Boolean,
      default: () => false,
    },
    charactersRemaining: {
      type: Number,
      default: () => 0,
    },
    popoutReplyBox: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    replyButtonClass() {
      return {
        'bg-white': this.mode === REPLY_EDITOR_MODES.REPLY,
      };
    },
    noteButtonClass() {
      return {
        'bg-yellow-50': this.mode === REPLY_EDITOR_MODES.NOTE,
      };
    },
    charLengthClass() {
      return this.charactersRemaining < 0 ? 'message-error' : 'message-length';
    },
    characterLengthWarning() {
      return this.charactersRemaining < 0
        ? `${-this.charactersRemaining} ${CHAR_LENGTH_WARNING.NEGATIVE}`
        : `${this.charactersRemaining} ${CHAR_LENGTH_WARNING.UNDER_50}`;
    },
  },
  methods: {
    handleKeyEvents(e) {
      if (hasPressedAltAndPKey(e)) {
        this.handleNoteClick();
      }
      if (hasPressedAltAndLKey(e)) {
        this.handleReplyClick();
      }
    },
    handleReplyClick() {
      this.setReplyMode(REPLY_EDITOR_MODES.REPLY);
    },
    handleNoteClick() {
      this.setReplyMode(REPLY_EDITOR_MODES.NOTE);
    },
  },
};
</script>
