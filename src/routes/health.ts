import type { FastifyInstance } from 'fastify';

// GET /api/health - used by deploy platforms (Railway) and by agents to verify the server runs.
export async function healthRoutes(app: FastifyInstance): Promise<void> {
  app.get('/api/health', () => ({
    status: 'ok',
    uptime: process.uptime(),
  }));
}
