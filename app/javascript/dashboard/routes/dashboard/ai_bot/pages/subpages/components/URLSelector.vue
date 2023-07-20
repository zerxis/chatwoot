<template>
  <div class="h-full">
    <table class="url-selector--table h-full">
      <thead>
        <tr>
          <td class="pl-2">
            <div class="flex items-center">
              <input
                class="mb-0"
                name="select-all-links"
                type="checkbox"
                :checked="allLinksSelected ? 'checked' : ''"
                :title="$t('AI_BOTS.SELECT_LINKS.SELECT_ALL')"
                @click.self="selectAllLinks"
              />
            </div>
          </td>
          <td class="pl-2">{{ $t('AI_BOTS.SELECT_LINKS.LINK') }}</td>
        </tr>
      </thead>
      <tbody class="overflow-auto">
        <tr v-for="(link, index) in links" :key="index">
          <td class="flex items-center pl-2 py-3">
            <input
              type="checkbox"
              class="mb-0"
              :checked="isLinkSelected(link)"
              @click.self="() => handleSelectLink(link)"
            />
          </td>
          <td class="text-sm">
            {{ link }}
          </td>
        </tr>
      </tbody>
    </table>
    <div class="flex items-center justify-between">
      <p>
        {{
          $t('AI_BOTS.SELECT_LINKS.SELECTED_COUNT', {
            selected: selectedLinks.length,
            total: links.length,
          })
        }}
      </p>
      <woot-submit-button
        :button-text="$t('AI_BOTS.SELECT_LINKS.SUBMIT')"
        :loading="isLoading"
        :disabled="disableSubmitButton"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    links: {
      type: Array,
      default: () => [],
    },
    selectedLinks: {
      type: Array,
      default: () => [],
    },
    submitButtonText: {
      type: String,
      default: '',
    },
    isLoading: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {};
  },
  computed: {
    selectedLinksCount() {
      return this.selectedLinks.length;
    },
    allLinksSelected() {
      return this.selectedLinks.length === this.links.length;
    },
    disableSubmitButton() {
      return this.selectedLinksCount === 0;
    },
  },
  methods: {
    isLinkSelected(link) {
      return this.selectedLinks.includes(link);
    },
    handleSelectLink(link) {
      const shouldRemove = this.isLinkSelected(link);

      let result = [];
      if (shouldRemove) {
        result = this.selectedLinks.filter(item => item !== link);
      } else {
        result = [...this.selectedLinks, link];
      }

      this.$emit('update', result);
    },
    selectAllLinks() {
      this.$emit('update', [...this.links]);
    },
  },
};
</script>

<style scoped lang="scss">
.url-selector--table {
  input {
    @apply mb-0;
  }
}
.checkbox-cell {
  width: var(--space-larger);
}
</style>
