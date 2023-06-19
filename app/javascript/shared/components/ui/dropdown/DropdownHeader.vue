<template>
  <li class="inline-flex list-none" :tabindex="null" :aria-disabled="true">
    <span class="block text-xs font-medium text-slate-600 mb-1 p-2">
      {{ title }}
    </span>
    <slot />
  </li>
</template>
<script>
export default {
  componentName: 'WootDropdownMenu',
  props: {
    title: {
      type: String,
      default: '',
    },
  },
};
</script>
