'use strict';

const { Pool } = require('pg');
const { logger } = require('./logger');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432', 10),
  database: process.env.DB_NAME || 'appdb',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 10,                  // max pool size
  idleTimeoutMillis: 30_000,
  connectionTimeoutMillis: 5_000,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: true } : false,
});

pool.on('error', (err) => {
  logger.error({ err }, 'Unexpected PostgreSQL pool error');
});

/**
 * Attempt to connect and run migrations, retrying on failure.
 * RDS takes time to become available after Terraform provisions it,
 * so this prevents container crashes during cold starts.
 */
async function connectWithRetry(retries = 10, delayMs = 5_000) {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const client = await pool.connect();
      logger.info('PostgreSQL connected');
      await runMigrations(client);
      client.release();
      return;
    } catch (err) {
      logger.warn({ attempt, retries, err: err.message }, 'DB connection failed, retrying…');
      if (attempt === retries) throw err;
      await sleep(delayMs);
    }
  }
}

async function runMigrations(client) {
  await client.query(`
    CREATE TABLE IF NOT EXISTS tasks (
      id        SERIAL PRIMARY KEY,
      title     VARCHAR(255) NOT NULL,
      done      BOOLEAN      NOT NULL DEFAULT FALSE,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  `);
  logger.info('Migrations complete');
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

module.exports = { pool, connectWithRetry };
