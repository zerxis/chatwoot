<template>
  <button
    class="cursor-pointer"
    :type="type"
    :class="buttonClasses"
    :disabled="isDisabled || isLoading"
    @click="handleClick"
  >
    <spinner
      v-if="isLoading"
      size="small"
      :color-scheme="showDarkSpinner ? 'dark' : ''"
    />
    <emoji-or-icon
      v-else-if="icon || emoji"
      class="min-w-[1rem]"
      :emoji="emoji"
      :icon="icon"
      :icon-size="iconSize"
    />
    <span v-if="$slots.default" :class="{ 'pl-2': icon || emoji }">
      <slot />
    </span>
  </button>
</template>
<script>
import Spinner from 'shared/components/Spinner';
import EmojiOrIcon from 'shared/components/EmojiOrIcon';

export default {
  name: 'WootButton',
  components: { EmojiOrIcon, Spinner },
  props: {
    type: {
      type: String,
      default: 'submit',
    },
    variant: {
      type: String,
      default: '',
    },
    size: {
      type: String,
      default: '',
    },
    icon: {
      type: String,
      default: '',
    },
    emoji: {
      type: String,
      default: '',
    },
    colorScheme: {
      type: String,
      default: 'primary',
    },
    classNames: {
      type: [String, Object],
      default: '',
    },
    isDisabled: {
      type: Boolean,
      default: false,
    },
    isLoading: {
      type: Boolean,
      default: false,
    },
    isExpanded: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    componentClassName() {
      const classes = {
        'secondary:clear:small':
          'text-xs font-medium text-slate-700 dark:text-slate-100  p-2 flex items-center hover:bg-slate-50 rounded hover:text-body',
        'secondary:clear:tiny':
          'text-xs font-medium text-slate-500 dark:text-slate-100 p-1 flex items-center hover:bg-slate-25 rounded hover:text-body',
        'primary:smooth:small':
          'text-xs font-medium text-slate-700 bg-woot-50 p-2 flex items-center hover:bg-slate-50 rounded hover:text-body',
      };
      return classes[`${this.colorScheme}:${this.variant}:${this.size}`];
    },

    variantClasses() {
      if (this.variant.includes('link')) {
        return `clear ${this.variant}`;
      }
      return this.variant;
    },
    hasOnlyIcon() {
      const hasEmojiOrIcon = this.emoji || this.icon;
      return !this.$slots.default && hasEmojiOrIcon;
    },
    hasOnlyIconClasses() {
      return this.hasOnlyIcon ? 'button--only-icon' : '';
    },
    buttonClasses() {
      return [
        this.variantClasses,
        this.hasOnlyIconClasses,
        this.size,
        this.colorScheme,
        this.classNames,
        this.isDisabled ? 'disabled' : '',
        this.isExpanded ? 'expanded' : '',
        this.componentClassName,
      ];
    },
    iconSize() {
      switch (this.size) {
        case 'tiny':
          return 12;
        case 'small':
          return 14;
        case 'medium':
          return 16;
        case 'large':
          return 18;

        default:
          return 16;
      }
    },
    showDarkSpinner() {
      return (
        this.colorScheme === 'secondary' ||
        this.variant === 'clear' ||
        this.variant === 'link' ||
        this.variant === 'hollow'
      );
    },
  },
  methods: {
    handleClick(evt) {
      this.$emit('click', evt);
    },
  },
};
</script>
