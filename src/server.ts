import Fastify, { type FastifyInstance } from 'fastify';

import { echoRoutes } from './routes/echo.js';
import { healthRoutes } from './routes/health.js';

export function buildServer(): FastifyInstance {
  const app = Fastify({ logger: true });
  void app.register(healthRoutes);
  void app.register(echoRoutes);
  return app;
}

// Start listening only when run directly (`npm run dev` / `npm start`),
// not when imported by tests - tests use app.inject() instead.
if (import.meta.url === `file://${process.argv[1]}`) {
  const app = buildServer();
  const port = Number(process.env.PORT ?? 3000);
  app.listen({ port, host: '0.0.0.0' }).catch((error: unknown) => {
    app.log.error(error);
    process.exit(1);
  });
}
