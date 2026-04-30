'use strict';

const { Router } = require('express');
const { pool } = require('../db');

const router = Router();

/**
 * GET /health/live  — liveness probe (is the process alive?)
 * ALB and ECS use this to decide whether to restart the container.
 * Intentionally lightweight: no DB check.
 */
router.get('/live', (_req, res) => {
  res.status(200).json({ status: 'ok', uptime: process.uptime() });
});

/**
 * GET /health/ready — readiness probe (can we serve traffic?)
 * Checks the DB connection pool before accepting requests.
 * ALB deregisters tasks that fail this check.
 */
router.get('/ready', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.status(200).json({ status: 'ready', db: 'connected' });
  } catch (err) {
    res.status(503).json({ status: 'not ready', db: 'disconnected', error: err.message });
  }
});

module.exports = router;
