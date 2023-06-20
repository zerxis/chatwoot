<template>
  <div
    class="w-100 p-1 rounded-sm relative bg-white justify-between flex items-center menu hover:bg-woot-75"
    :class="{ 'opacity-50 cursor-not-allowed': !subMenuAvailable }"
  >
    <div class="flex items-center">
      <fluent-icon :icon="option.icon" size="14" class="menu-icon" />
      <p class="mx-2 text-xs">{{ option.label }}</p>
    </div>
    <fluent-icon icon="chevron-right" size="12" />
    <div v-if="subMenuAvailable" class="submenu">
      <slot />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    option: {
      type: Object,
      default: () => {},
    },
    subMenuAvailable: {
      type: Boolean,
      default: true,
    },
  },
};
</script>

<style scoped lang="scss">
.submenu {
  padding: var(--space-smaller);
  background-color: var(--white);
  box-shadow: var(--shadow-context-menu);
  border-radius: var(--border-radius-normal);
  position: absolute;
  position: absolute;
  left: 100%;
  top: 0;
  display: none;
  min-height: min-content;
  max-height: var(--space-giga);
  overflow-y: auto;
  // Need this because Firefox adds a horizontal scrollbar, if a text is truncated inside.
  overflow-x: hidden;
}

.menu {
  &:hover {
    .submenu {
      display: block;
    }
    &:before {
      content: '';
      position: absolute;
      z-index: var(--z-index-highest);
      bottom: -65%;
      height: 75%;
      right: 0%;
      width: 50%;
      clip-path: polygon(100% 0, 0% 0%, 100% 100%);
    }
  }
}
</style>
