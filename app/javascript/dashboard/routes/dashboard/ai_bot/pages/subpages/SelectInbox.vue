<template>
  <div class="p-8">
    <page-header
      class="w-3/4"
      content-class="mt-2"
      :header-title="$t('AI_BOTS.SELECT_INBOX.TITLE')"
      :header-content="$t('AI_BOTS.SELECT_INBOX.DESC')"
    />
    <form class="w-3/4" @submit.prevent="onSubmit">
      <multiselect
        v-model="targetInbox"
        track-by="id"
        class="w-3/4 text-sm mt-5"
        label="name"
        placeholder="Choose an inbox to deploy the bot"
        selected-label=""
        select-label=""
        deselect-label=""
        :max-height="160"
        :close-on-select="true"
        :options="[...inboxes]"
      >
        <template slot="singleLabel" slot-scope="{ option }">
          <inbox-dropdown-item
            v-if="option.name"
            :name="option.name"
            :inbox-identifier="computedInboxSource(option)"
            :channel-type="option.channel_type"
          />
          <span v-else>
            {{ $t('NEW_CONVERSATION.FORM.INBOX.PLACEHOLDER') }}
          </span>
        </template>
        <template slot="option" slot-scope="{ option }">
          <inbox-dropdown-item
            :name="option.name"
            :inbox-identifier="computedInboxSource(option)"
            :channel-type="option.channel_type"
          />
        </template>
      </multiselect>
      <woot-submit-button
        :disabled="$v.targetInbox.$invalid || uiFlags.isCreating"
        :button-text="$t('AI_BOTS.INITIALIZE.FORM.SUBMIT')"
        :loading="uiFlags.isCreating"
      />
    </form>
  </div>
</template>
<script>
import InboxDropdownItem from 'dashboard/components/widgets/InboxDropdownItem';

import PageHeader from 'dashboard/routes/dashboard/settings/SettingsSubPageHeader.vue';
import { required } from 'vuelidate/lib/validators';
import { mapGetters } from 'vuex';
import { getInboxSource } from 'dashboard/helper/inbox';
export default {
  components: {
    PageHeader,
    InboxDropdownItem,
  },
  validations: {
    targetInbox: {
      required,
    },
  },
  data() {
    return {
      targetInbox: {},
      inboxId: '',
    };
  },
  computed: {
    ...mapGetters({
      inboxes: 'inboxes/getInboxes',
      uiFlags: 'responseSources/getUIFlags',
    }),
  },
  methods: {
    onSubmit() {
      try {
        const responseSource = this.$store.dispatch('responseSources/create', {
          response_documents_attributes: this.$route.params.selectedLinks.map(
            item => ({
              document_link: item,
            })
          ),
          inbox_id: this.targetInbox.id,
          name: 'Test',
          source_link: '',
        });
        this.$router.push({
          name: 'ai_bots_new_finish',
          params: { responseSource: responseSource.id },
        });
      } catch (error) {
        console.log(error);
      }
    },

    computedInboxSource(inbox) {
      if (!inbox.channel_type) return '';
      const classByType = getInboxSource(
        inbox.channel_type,
        inbox.phone_number,
        inbox
      );
      return classByType;
    },
  },
};
</script>
