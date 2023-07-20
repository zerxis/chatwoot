<template>
  <div class="h-full w-full bg-slate-25 dark:bg-slate-800 flex">
    <div
      v-if="uiFlags.isFetching"
      class="flex-1 flex items-center justify-center"
    >
      <spinner size="" color-scheme="primary" />
      <span>
        {{ $t('AI_BOTS.LOADING_RESPONSE_SOURCES') }}
      </span>
    </div>
    <div
      v-else-if="!responseSources.length"
      class="w-full h-full flex flex-col items-center justify-center"
    >
      <p class="text-lg">
        {{ $t('AI_BOTS.NO_RESPONSE_SOURCES_FOUND') }}
      </p>
      <woot-button icon="add" @click="onClick">
        {{ $t('AI_BOTS.LET_US_GET_STARTED') }}
      </woot-button>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import Spinner from 'shared/components/Spinner.vue';
export default {
  components: { Spinner },
  computed: {
    ...mapGetters({
      uiFlags: 'responseSources/getUIFlags',
      responseSources: 'responseSources/getResponseSources',
    }),
  },
  mounted() {
    this.$store.dispatch('responseSources/get');
  },
  methods: {
    onClick() {
      this.$router.push({ name: 'ai_bots_new_initialize' });
    },
  },
};
</script>
