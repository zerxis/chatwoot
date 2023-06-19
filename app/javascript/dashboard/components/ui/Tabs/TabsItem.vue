<template>
  <li
    :class="{
      'mx-2 text-slate-500 hover:text-slate-600 cursor-pointer first:ml-0 float-left flex items-center justify-center border-b-2 border-transparent': true,
      'border-woot-500 text-woot-500': active,
    }"
  >
    <a class="py-2" @click="onTabClick">
      {{ name }}
      <span
        v-if="showBadge"
        class="inline-block bg-slate-50 rounded-full text-xxs min-w-[1.25rem] text-center font-semibold px-1 py-0"
      >
        {{ getItemCount }}
      </span>
    </a>
  </li>
</template>
<script>
export default {
  name: 'WootTabsItem',
  props: {
    index: {
      type: Number,
      default: 0,
    },
    name: {
      type: String,
      required: true,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    count: {
      type: Number,
      default: 0,
    },
    showBadge: {
      type: Boolean,
      default: true,
    },
  },

  computed: {
    active() {
      return this.index === this.$parent.index;
    },

    getItemCount() {
      return this.count;
    },
  },

  methods: {
    onTabClick(event) {
      event.preventDefault();
      if (!this.disabled) {
        this.$parent.$emit('change', this.index);
      }
    },
  },
};
</script>
