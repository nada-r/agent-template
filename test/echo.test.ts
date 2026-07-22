import { describe, expect, it } from 'vitest';

import { buildServer } from '../src/server.js';

describe('POST /api/echo', () => {
  it('echoes a valid message', async () => {
    const app = buildServer();
    const res = await app.inject({
      method: 'POST',
      url: '/api/echo',
      payload: { message: 'hello' },
    });

    expect(res.statusCode).toBe(200);
    expect(res.json()).toEqual({ echo: 'hello' });
    await app.close();
  });

  it('rejects an invalid body with 400', async () => {
    const app = buildServer();
    const res = await app.inject({
      method: 'POST',
      url: '/api/echo',
      payload: { message: '' },
    });

    expect(res.statusCode).toBe(400);
    expect(res.json()).toMatchObject({ error: 'Invalid body' });
    await app.close();
  });
});
