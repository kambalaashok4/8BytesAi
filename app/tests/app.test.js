'use strict';

const request = require('supertest');

// ── Mock the DB pool before requiring app ─────────────────────────────────────
jest.mock('../src/db', () => {
  const mockPool = {
    query: jest.fn(),
    on: jest.fn(),
  };
  return {
    pool: mockPool,
    connectWithRetry: jest.fn().mockResolvedValue(undefined),
  };
});

const { pool } = require('../src/db');
const app = require('../src/index');

// ── Health routes ─────────────────────────────────────────────────────────────
describe('GET /health/live', () => {
  it('returns 200 with uptime', async () => {
    const res = await request(app).get('/health/live');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('status', 'ok');
    expect(res.body).toHaveProperty('uptime');
  });
});

describe('GET /health/ready', () => {
  it('returns 200 when DB is reachable', async () => {
    pool.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });
    const res = await request(app).get('/health/ready');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ready');
  });

  it('returns 503 when DB is unreachable', async () => {
    pool.query.mockRejectedValueOnce(new Error('connection refused'));
    const res = await request(app).get('/health/ready');
    expect(res.status).toBe(503);
    expect(res.body.status).toBe('not ready');
  });
});

// ── Tasks routes ──────────────────────────────────────────────────────────────
describe('GET /api/tasks', () => {
  it('returns a list of tasks', async () => {
    pool.query.mockResolvedValueOnce({
      rows: [{ id: 1, title: 'Test task', done: false }],
    });
    const res = await request(app).get('/api/tasks');
    expect(res.status).toBe(200);
    expect(res.body.data).toHaveLength(1);
    expect(res.body.data[0].title).toBe('Test task');
  });
});

describe('POST /api/tasks', () => {
  it('creates a task and returns 201', async () => {
    const task = { id: 1, title: 'New task', done: false };
    pool.query.mockResolvedValueOnce({ rows: [task] });
    const res = await request(app).post('/api/tasks').send({ title: 'New task' });
    expect(res.status).toBe(201);
    expect(res.body.data.title).toBe('New task');
  });

  it('rejects missing title with 400', async () => {
    const res = await request(app).post('/api/tasks').send({});
    expect(res.status).toBe(400);
  });

  it('rejects blank title with 400', async () => {
    const res = await request(app).post('/api/tasks').send({ title: '   ' });
    expect(res.status).toBe(400);
  });
});

describe('PATCH /api/tasks/:id', () => {
  it('updates a task', async () => {
    pool.query.mockResolvedValueOnce({ rows: [{ id: 1, title: 'Updated', done: true }] });
    const res = await request(app).patch('/api/tasks/1').send({ done: true });
    expect(res.status).toBe(200);
    expect(res.body.data.done).toBe(true);
  });

  it('returns 404 for unknown task', async () => {
    pool.query.mockResolvedValueOnce({ rows: [] });
    const res = await request(app).patch('/api/tasks/999').send({ done: true });
    expect(res.status).toBe(404);
  });
});

describe('DELETE /api/tasks/:id', () => {
  it('deletes a task and returns 204', async () => {
    pool.query.mockResolvedValueOnce({ rowCount: 1 });
    const res = await request(app).delete('/api/tasks/1');
    expect(res.status).toBe(204);
  });

  it('returns 404 for unknown task', async () => {
    pool.query.mockResolvedValueOnce({ rowCount: 0 });
    const res = await request(app).delete('/api/tasks/999');
    expect(res.status).toBe(404);
  });
});
