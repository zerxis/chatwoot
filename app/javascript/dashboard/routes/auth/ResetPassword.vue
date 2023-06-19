<template>
  <form
    class="sm:mx-auto sm:w-full sm:max-w-lg bg-white dark:bg-slate-800 p-11 shadow sm:shadow-lg sm:rounded-lg"
    @submit.prevent="submit"
  >
    <h1
      class="mb-1 text-left text-2xl font-medium tracking-tight text-slate-900 dark:text-white"
    >
      {{ $t('RESET_PASSWORD.TITLE') }}
    </h1>
    <p
      class="text-sm text-slate-600 dark:text-woot-50 tracking-normal font-normal leading-6 mb-4"
    >
      {{
        useInstallationName(
          $t('RESET_PASSWORD.DESCRIPTION'),
          globalConfig.installationName
        )
      }}
    </p>
    <div class="column log-in-form space-y-5">
      <form-input
        v-model.trim="credentials.email"
        name="email_address"
        :has-error="$v.credentials.email.$error"
        :error-message="$t('RESET_PASSWORD.EMAIL.ERROR')"
        :placeholder="$t('RESET_PASSWORD.EMAIL.PLACEHOLDER')"
        @input="$v.credentials.email.$touch"
      />
      <woot-submit-button
        :disabled="$v.credentials.email.$invalid || resetPassword.showLoading"
        :button-text="$t('RESET_PASSWORD.SUBMIT')"
        :loading="resetPassword.showLoading"
      />
    </div>
    <p class="text-sm text-slate-600 dark:text-woot-50 mt-4 -mb-1">
      {{ $t('RESET_PASSWORD.GO_BACK_TO_LOGIN') }}
      <router-link to="/auth/login">
        {{ $t('COMMON.CLICK_HERE') }}.
      </router-link>
    </p>
  </form>
</template>

<script>
import { required, minLength, email } from 'vuelidate/lib/validators';
import Auth from '../../api/auth';
import globalConfigMixin from 'shared/mixins/globalConfigMixin';
import { mapGetters } from 'vuex';
import FormInput from '../../components/v3/FormInput.vue';

export default {
  components: { FormInput },
  mixins: [globalConfigMixin],
  data() {
    return {
      credentials: { email: '' },
      resetPassword: {
        message: '',
        showLoading: false,
      },
      error: '',
    };
  },
  computed: {
    ...mapGetters({ globalConfig: 'globalConfig/get' }),
  },
  validations: {
    credentials: {
      email: {
        required,
        email,
        minLength: minLength(4),
      },
    },
  },
  methods: {
    showAlert(message) {
      // Reset loading, current selected agent
      this.resetPassword.showLoading = false;
      bus.$emit('newToastMessage', message);
    },
    submit() {
      this.resetPassword.showLoading = true;
      Auth.resetPassword(this.credentials)
        .then(res => {
          let successMessage = this.$t('RESET_PASSWORD.API.SUCCESS_MESSAGE');
          if (res.data && res.data.message) {
            successMessage = res.data.message;
          }
          this.showAlert(successMessage);
        })
        .catch(error => {
          let errorMessage = this.$t('RESET_PASSWORD.API.ERROR_MESSAGE');
          if (error?.response?.data?.message) {
            errorMessage = error.response.data.message;
          }
          this.showAlert(errorMessage);
        });
    },
  },
};
</script>
