import type { FastifyInstance } from 'fastify';
import { z } from 'zod';

// Canonical route pattern for this repo: Zod schema at the boundary, types inferred from it.
// New endpoints should follow this file's shape (see .claude/skills/new-endpoint).
const EchoBody = z.object({
  message: z.string().min(1),
});
type EchoBody = z.infer<typeof EchoBody>;

export async function echoRoutes(app: FastifyInstance): Promise<void> {
  app.post('/api/echo', async (request, reply) => {
    const parsed = EchoBody.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: 'Invalid body', issues: parsed.error.issues });
    }
    const body: EchoBody = parsed.data;
    return { echo: body.message };
  });
}
