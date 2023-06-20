<template>
  <div
    class="flex items-center flex-nowrap w-64 p-1 rounded-sm overflow-hidden hover:bg-woot-500 hover:text-white"
    role="button"
    @click.stop="$emit('click')"
  >
    <fluent-icon
      v-if="variant === 'icon' && option.icon"
      :icon="option.icon"
      size="14"
    />
    <span
      v-if="variant === 'label' && option.color"
      class="w-3 h-3 rounded-sm border border-slate-50 shrink-0"
      :style="{ backgroundColor: option.color }"
    />
    <thumbnail
      v-if="variant === 'agent'"
      :username="option.label"
      :src="option.thumbnail"
      :status="option.status"
      size="20px"
      class="mt-0"
    />
    <p class="mx-2 text-xs shrink-0 truncate">{{ option.label }}</p>
  </div>
</template>

<script>
import Thumbnail from 'dashboard/components/widgets/Thumbnail.vue';
export default {
  components: {
    Thumbnail,
  },
  props: {
    option: {
      type: Object,
      default: () => {},
    },
    variant: {
      type: String,
      default: 'default',
    },
  },
};
</script>
