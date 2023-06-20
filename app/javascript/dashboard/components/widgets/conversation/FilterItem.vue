<template>
  <select
    v-model="activeValue"
    class="block w-32 rounded-md border-0 px-2 py-1 text-slate-700 ring-1 ring-inset ring-slate-100 focus:ring-2 focus:ring-woot-600 text-xs"
    @change="onFilterChange"
  >
    <option v-for="(value, status) in items" :key="status" :value="status">
      {{ $t(`${pathPrefix}.${status}.TEXT`) }}
    </option>
  </select>
</template>
<script>
export default {
  props: {
    selectedValue: {
      type: String,
      required: true,
    },
    items: {
      type: Object,
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
    pathPrefix: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      activeValue: this.selectedValue,
    };
  },
  methods: {
    onFilterChange() {
      if (this.type === 'status') {
        this.$store.dispatch('setChatStatusFilter', this.activeValue);
      } else {
        this.$store.dispatch('setChatSortFilter', this.activeValue);
      }
      this.$emit('onChangeFilter', this.activeValue, this.type);
    },
  },
};
</script>
