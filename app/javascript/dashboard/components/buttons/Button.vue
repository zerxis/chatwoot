<template>
  <button :type="type" :class="variant" @click="onClick">
    <fluent-icon
      v-if="!isLoading && icon"
      :class="buttonIconClass"
      :icon="icon"
    />
    <spinner v-if="isLoading" />
    <slot />
  </button>
</template>

<script>
export default {
  props: {
    isLoading: {
      type: Boolean,
      default: false,
    },
    icon: {
      type: String,
      default: '',
    },
    buttonIconClass: {
      type: String,
      default: '',
    },
    type: {
      type: String,
      default: 'button',
    },
    variant: {
      type: String,
      default: 'primary',
    },
  },
  computed: {
    buttonClasses() {
      const listOfClasses = {
        clear:
          'text-xs font-medium text-slate-700 w-full py-1 px-4 flex items-center',
      };
      return listOfClasses[this.variant] || '';
    },
  },
  methods: {
    onClick(e) {
      this.$emit('click', e);
    },
  },
};
</script>
