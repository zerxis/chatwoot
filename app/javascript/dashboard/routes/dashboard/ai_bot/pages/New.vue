<template>
  <div class="w-full h-full flex bg-slate-25 dark:bg-slate-800">
    <woot-wizard class="flex-1 px-4 py-8" :items="$t('AI_BOTS.CREATE_FLOW')" />
    <div class="flex-[3_3_0%] bg-white dark:bg-slate-700 h-full">
      <router-view />
    </div>
  </div>
</template>

<script>
export default {};
</script>
