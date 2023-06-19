<template>
  <div
    class="inline-block w-2 h-2 ml-1 mr-0.5 rounded-3xl"
    :class="{
      'bg-green-400': status === 'online',
      'bg-slate-500': status === 'offline',
      'bg-yellow-500': status === 'busy',
    }"
  />
</template>
<script>
export default {
  props: {
    status: { type: String, default: '' },
  },
};
</script>
