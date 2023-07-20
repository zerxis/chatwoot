<template>
  <div class="p-8">
    <page-header
      class="w-3/4"
      content-class="mt-2"
      :header-title="$t('AI_BOTS.INITIALIZE.TITLE')"
      :header-content="$t('AI_BOTS.INITIALIZE.DESC')"
    />
    <form @submit.prevent="onSubmit">
      <woot-input
        v-model.trim="link"
        :class="{ error: $v.link.$error }"
        class="w-1/2 h-12 mt-4"
        :placeholder="$t('AI_BOTS.INITIALIZE.FORM.LINK.PLACEHOLDER')"
        @input="$v.link.$touch"
      />
      <woot-submit-button
        :disabled="$v.link.$invalid || uiFlags.isParsing"
        :button-text="$t('AI_BOTS.INITIALIZE.FORM.SUBMIT')"
        :loading="uiFlags.isParsing"
      />
    </form>
  </div>
</template>
<script>
import PageHeader from 'dashboard/routes/dashboard/settings/SettingsSubPageHeader.vue';
import { required, url, minLength } from 'vuelidate/lib/validators';
import { mapGetters } from 'vuex';
export default {
  components: {
    PageHeader,
  },
  validations: {
    link: {
      required,
      minLength: minLength(7),
      url,
    },
  },
  data() {
    return {
      link: '',
    };
  },
  computed: {
    ...mapGetters({
      uiFlags: 'responseSources/getUIFlags',
    }),
  },
  methods: {
    onSubmit() {
      try {
        this.$store.dispatch('responseSources/parse', { link: this.link });
        this.$router.push({ name: 'ai_bots_new_select_links' });
      } catch (error) {
        console.log(error);
      }
    },
  },
};
</script>
