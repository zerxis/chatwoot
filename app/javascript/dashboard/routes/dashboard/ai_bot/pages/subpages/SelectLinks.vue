<template>
  <div class="p-8 flex flex-col h-full">
    <page-header
      class="w-3/4"
      content-class="mt-2"
      :header-title="$t('AI_BOTS.SELECT_LINKS.TITLE')"
      :header-content="$t('AI_BOTS.SELECT_LINKS.DESC')"
    />
    <div class="overflow-auto h-full">
      <url-selector
        :links="parsedLinks"
        :selected-links="selectedLinks"
        @update="onUpdate"
      />
    </div>
  </div>
</template>
<script>
import { mapGetters } from 'vuex';
import PageHeader from 'dashboard/routes/dashboard/settings/SettingsSubPageHeader.vue';
import UrlSelector from './components/URLSelector.vue';

export default {
  components: { PageHeader, UrlSelector },
  data() {
    return {
      selectedLinks: [],
    };
  },
  computed: {
    ...mapGetters({
      parsedLinks: 'responseSources/getParsedLinks',
    }),
  },
  mounted() {
    console.log(this.parsedLinks);
    // if (!this.parsedLinks.length) {
    //   this.$router.push({ name: 'ai_bots_new_initialize' });
    // }
  },
  methods: {
    onUpdate(selectedLinks) {
      this.selectedLinks = selectedLinks;
    },
  },
};
</script>
