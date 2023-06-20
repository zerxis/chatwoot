<template>
  <div v-show="activeLabels.length" ref="labelContainer" class="my-1 w-full">
    <div
      class="flex items-center min-w-0 flex-flow-row-wrap"
      :class="{ expand: showAllLabels }"
    >
      <woot-label
        v-for="(label, index) in activeLabels"
        :key="label.id"
        :title="label.title"
        :description="label.description"
        :color="label.color"
        variant="smooth"
        small
        :class="{
          'invisible absolute': !showAllLabels && index > labelPosition,
        }"
      />
      <woot-button
        v-if="showExpandLabelButton"
        :title="
          showAllLabels
            ? $t('CONVERSATION.CARD.HIDE_LABELS')
            : $t('CONVERSATION.CARD.SHOW_LABELS')
        "
        class="h-5 shrink-0 sticky right-0 mr-2"
        color-scheme="secondary"
        variant="hollow"
        :icon="showAllLabels ? 'chevron-left' : 'chevron-right'"
        size="tiny"
        @click="onShowLabels"
      />
    </div>
  </div>
</template>
<script>
import conversationLabelMixin from 'dashboard/mixins/conversation/labelMixin';
export default {
  mixins: [conversationLabelMixin],
  props: {
    conversationId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      showAllLabels: false,
      showExpandLabelButton: false,
      labelPosition: -1,
    };
  },
  watch: {
    activeLabels() {
      this.$nextTick(() => this.computeVisibleLabelPosition());
    },
  },
  mounted() {
    this.computeVisibleLabelPosition();
  },
  methods: {
    onShowLabels(e) {
      e.stopPropagation();
      this.showAllLabels = !this.showAllLabels;
    },
    computeVisibleLabelPosition() {
      const labelContainer = this.$refs.labelContainer;
      const labels = this.$refs.labelContainer.querySelectorAll('.label');
      let labelOffset = 0;
      this.showExpandLabelButton = false;

      Array.from(labels).forEach((label, index) => {
        labelOffset += label.offsetWidth + 8;

        if (labelOffset < labelContainer.clientWidth) {
          this.labelPosition = index;
        } else {
          this.showExpandLabelButton = true;
        }
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.labels-wrap {
  display: flex;
  align-items: center;
  min-width: 0;
  flex-shrink: 1;

  &.expand {
    height: auto;
    overflow: visible;
    flex-flow: row wrap;

    .label {
      margin-bottom: var(--space-smaller);
    }

    .show-more--button {
      margin-bottom: var(--space-smaller);
    }
  }

  .secondary {
    border: 1px solid var(--s-100);
  }

  .label {
    margin-bottom: 0;
  }
}
</style>
