import { frontendURL } from '../../../helper/URLHelper';
const Index = () => import('./pages/Index.vue');
const New = () => import('./pages/New.vue');
const Initialize = () => import('./pages/subpages/Initialize.vue');
const SelectLinks = () => import('./pages/subpages/SelectLinks.vue');
const SelectInbox = () => import('./pages/subpages/SelectInbox.vue');
const Finish = () => import('./pages/subpages/Finish.vue');

export default {
  routes: [
    {
      path: frontendURL('accounts/:accountId/ai_bots'),
      name: 'ai_bots_home',
      roles: ['administrator'],
      component: Index,
    },
    {
      path: frontendURL('accounts/:accountId/ai_bots/new'),
      component: New,
      children: [
        {
          path: '',
          name: 'ai_bots_new_initialize',
          component: Initialize,
          roles: ['administrator'],
        },
        {
          path: frontendURL('accounts/:accountId/ai_bots/new/select_links'),
          name: 'ai_bots_new_select_links',
          component: SelectLinks,
          roles: ['administrator'],
        },
        {
          path: frontendURL('accounts/:accountId/ai_bots/new/select_inbox'),
          name: 'ai_bots_new_select_inbox',
          roles: ['administrator'],
          component: SelectInbox,
        },

        {
          path: frontendURL(
            'accounts/:accountId/ai_bots/new/:responseSourceId/finish'
          ),
          name: 'ai_bots_new_finish',
          roles: ['administrator'],
          component: Finish,
        },
      ],
    },
  ],
};
