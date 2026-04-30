'use strict';

const pino = require('pino');

/**
 * Structured JSON logging via pino.
 * In production this goes to stdout → CloudWatch Logs (ECS log driver).
 * In development, pretty-print for readability.
 */
const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  ...(process.env.NODE_ENV !== 'production' && {
    transport: { target: 'pino-pretty', options: { colorize: true } },
  }),
  base: {
    service: 'devops-app',
    env: process.env.NODE_ENV,
    version: process.env.APP_VERSION || 'unknown',
  },
});

module.exports = { logger };
