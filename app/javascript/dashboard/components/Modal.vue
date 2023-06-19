<template>
  <transition name="modal-fade">
    <div
      v-if="show"
      :class="modalClassName"
      transition="modal"
      @click="onBackDropClick"
    >
      <div
        class="bg-white rounded-sm max-w-full overflow-auto relative w-[40rem] p-8 shadow-lg"
        :class="modalContainerClassName"
        @click.stop
      >
        <woot-button
          v-if="showCloseButton"
          color-scheme="secondary"
          icon="dismiss"
          variant="clear"
          class="absolute top-4 right-4 hover:bg-woot-25"
          @click="close"
        />
        <slot />
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    closeOnBackdropClick: {
      type: Boolean,
      default: true,
    },
    show: Boolean,
    showCloseButton: {
      type: Boolean,
      default: true,
    },
    onClose: {
      type: Function,
      required: true,
    },
    fullWidth: {
      type: Boolean,
      default: false,
    },
    modalType: {
      type: String,
      default: 'centered',
    },
    size: {
      type: String,
      default: '',
    },
  },
  computed: {
    modalContainerClassName() {
      let className = 'modal-container skip-context-menu';
      if (this.fullWidth) {
        return `${className} modal-container--full-width`;
      }

      return `${className} ${this.size}`;
    },
    modalClassName() {
      const modalClassNameMap = {
        centered: '',
        'right-aligned': 'right-aligned',
      };

      return `mask rounded-lg skip-context-menu ${modalClassNameMap[
        this.modalType
      ] || ''}`;
    },
  },
  mounted() {
    document.addEventListener('keydown', e => {
      if (this.show && e.code === 'Escape') {
        this.onClose();
      }
    });
  },
  methods: {
    close() {
      this.onClose();
    },
    onBackDropClick() {
      if (this.closeOnBackdropClick) {
        this.onClose();
      }
    },
  },
};
</script>
