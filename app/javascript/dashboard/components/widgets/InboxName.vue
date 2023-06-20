<template>
  <div
    class="inline-flex items-center py-0.5 leading-3 font-medium text-xs text-slate-600"
  >
    <fluent-icon class="mr-1" :icon="computedInboxClass" size="10" />
    {{ inbox.name }}
  </div>
</template>
<script>
import { getInboxClassByType } from 'dashboard/helper/inbox';

export default {
  props: {
    inbox: {
      type: Object,
      default: () => {},
    },
  },
  computed: {
    computedInboxClass() {
      const { phone_number: phoneNumber, channel_type: type } = this.inbox;
      const classByType = getInboxClassByType(type, phoneNumber);
      return classByType;
    },
  },
};
</script>
