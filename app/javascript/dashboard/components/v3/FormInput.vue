<template>
  <div>
    <label
      v-if="label"
      :for="name"
      class="flex justify-between text-sm font-medium leading-6 text-slate-900 dark:text-white"
      :class="{ 'text-red-500': hasError }"
    >
      {{ label }}
      <slot />
    </label>
    <div class="mt-2">
      <input
        :id="name"
        :name="name"
        :type="type"
        autocomplete="off"
        :required="required"
        :placeholder="placeholder"
        :value="value"
        class="block w-full rounded-md border-0 px-3 py-2 shadow-sm ring-1 ring-inset dark:bg-slate-600 dark:ring-slate-500 ring-slate-200 placeholder:text-slate-400 focus:ring-2 focus:ring-inset focus:ring-woot-500 sm:text-sm sm:leading-6 outline-none"
        :class="{ 'focus:ring-red-600 ring-red-600': hasError }"
        @input="onInput"
      />
      <span v-if="errorMessage && hasError" class="text-sm text-red-400">
        {{ errorMessage }}
      </span>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    label: {
      type: String,
      default: '',
    },
    name: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      default: 'text',
    },
    required: {
      type: Boolean,
      default: false,
    },
    placeholder: {
      type: String,
      default: '',
    },
    value: {
      type: [String, Number],
      default: '',
    },
    hasError: {
      type: Boolean,
      default: false,
    },
    errorMessage: {
      type: String,
      default: '',
    },
  },
  methods: {
    onInput(e) {
      this.$emit('input', e.target.value);
    },
  },
};
</script>
