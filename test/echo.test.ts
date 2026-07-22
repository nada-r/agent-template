import { describe, expect, it } from 'vitest';

import { buildServer } from '../src/server.js';

describe('POST /api/echo', () => {
  it('echoes a valid message', async () => {
    const app = buildServer();
    const response = await app.inject({
      method: 'POST',
      url: '/api/echo',
      payload: { message: 'hello' },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ echo: 'hello' });
    await app.close();
  });

  it('rejects an invalid body with 400', async () => {
    const app = buildServer();
    const response = await app.inject({
      method: 'POST',
      url: '/api/echo',
      payload: { message: '' },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json()).toMatchObject({ error: 'Invalid body' });
    await app.close();
  });
});
