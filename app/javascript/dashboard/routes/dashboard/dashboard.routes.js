import AppContainer from './Dashboard';
import settings from './settings/settings.routes';
import conversation from './conversation/conversation.routes';
import { routes as searchRoutes } from '../../modules/search/search.routes';
import { routes as contactRoutes } from './contacts/routes';
import { routes as notificationRoutes } from './notifications/routes';
import { frontendURL } from '../../helper/URLHelper';
import helpcenterRoutes from './helpcenter/helpcenter.routes';
import aiBotRoutes from './ai_bot/ai_bot.routes';

const Suspended = () => import('./suspended/Index');

export default {
  routes: [
    ...helpcenterRoutes.routes,
    {
      path: frontendURL('accounts/:account_id'),
      component: AppContainer,
      children: [
        ...conversation.routes,
        ...settings.routes,
        ...contactRoutes,
        ...searchRoutes,
        ...notificationRoutes,
        ...aiBotRoutes.routes,
      ],
    },
    {
      path: frontendURL('accounts/:accountId/suspended'),
      name: 'account_suspended',
      roles: ['administrator', 'agent'],
      component: Suspended,
    },
  ],
};
