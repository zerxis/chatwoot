<template>
  <div class="cw-accordion">
    <button
      class="flex cursor-grab items-center bg-slate-25 border-b border-t border-slate-100 justify-between py-2 px-3 w-full drag-handle"
      @click="$emit('click')"
    >
      <div class="flex justify-between mb-0.5">
        <emoji-or-icon class="icon-or-emoji" :icon="icon" :emoji="emoji" />
        <h5 class="pr-2 text-sm font-medium">
          {{ title }}
        </h5>
      </div>
      <div class="button-icon--wrap">
        <slot name="button" />
        <div class="chevron-icon__wrap">
          <fluent-icon v-if="isOpen" size="24" icon="subtract" type="solid" />
          <fluent-icon v-else size="24" icon="add" type="solid" />
        </div>
      </div>
    </button>
    <div
      v-if="isOpen"
      class="cw-accordion--content"
      :class="{ compact: compact }"
    >
      <slot />
    </div>
  </div>
</template>

<script>
import EmojiOrIcon from 'shared/components/EmojiOrIcon';

export default {
  components: {
    EmojiOrIcon,
  },
  props: {
    title: {
      type: String,
      required: true,
    },
    compact: {
      type: Boolean,
      default: false,
    },
    icon: {
      type: String,
      default: '',
    },
    emoji: {
      type: String,
      default: '',
    },
    isOpen: {
      type: Boolean,
      default: true,
    },
  },
};
</script>

<style lang="scss" scoped>
.cw-accordion {
  // This is done to fix contact sidebar border issues
  // If you are using it else, find a fix to remove this hack
  margin-top: -1px;
  font-size: var(--font-size-small);
}

.title-icon__wrap {
  display: flex;
  align-items: baseline;
}

.icon-or-emoji {
  display: inline-block;
  width: var(--space-two);
}

.button-icon--wrap {
  display: flex;
  flex-direction: row;
}

.chevron-icon__wrap {
  display: flex;
  justify-content: flex-end;
  width: var(--space-slab);
  color: var(--w-500);
}

.cw-accordion--content {
  padding: var(--space-normal);

  &.compact {
    padding: 0;
  }
}
</style>
