<template>
  <woot-button
    v-tooltip.left="$t('CONVERSATION.SWITCH_VIEW_LAYOUT')"
    icon="arrow-right-import"
    size="tiny"
    variant="smooth"
    :icon-class="isOnExpandedLayout ? 'rotate-180' : ''"
    color-scheme="secondary"
    @click="toggle"
  />
</template>

<script>
export default {
  props: {
    isOnExpandedLayout: {
      type: Boolean,
      default: false,
    },
  },
  methods: {
    toggle() {
      this.$emit('toggle');
    },
  },
};
</script>
