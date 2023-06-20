<template>
  <woot-button
    size="small"
    variant="clear"
    color-scheme="secondary"
    icon="list"
    class="-ml-2"
    @click="onMenuItemClick"
  />
</template>

<script>
import { BUS_EVENTS } from 'shared/constants/busEvents';

export default {
  methods: {
    onMenuItemClick() {
      bus.$emit(BUS_EVENTS.TOGGLE_SIDEMENU);
    },
  },
};
</script>
