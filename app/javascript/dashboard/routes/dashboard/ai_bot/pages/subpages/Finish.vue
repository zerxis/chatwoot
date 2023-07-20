<template>
  <div class="wizard-body content-box">
    <empty-state
      :title="$t('INBOX_MGMT.FINISH.TITLE')"
      message="message"
      :button-text="$t('INBOX_MGMT.FINISH.BUTTON_TEXT')"
    />
  </div>
</template>

<script>
import EmptyState from 'dashboard/components/widgets/EmptyState';

export default {
  components: {
    EmptyState,
  },
};
</script>
