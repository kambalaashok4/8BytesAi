'use strict';

const { Router } = require('express');
const client = require('prom-client');

const router = Router();

// Default metrics: event loop lag, heap usage, GC stats, etc.
client.collectDefaultMetrics({ prefix: 'app_' });

// Custom business metric
const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request latency',
  labelNames: ['method', 'route'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5],
});

// Middleware to track all routes — attach to app before routes
function metricsMiddleware(req, res, next) {
  const end = httpRequestDurationSeconds.startTimer({ method: req.method, route: req.path });
  res.on('finish', () => {
    httpRequestsTotal.inc({
      method: req.method,
      route: req.path,
      status_code: res.statusCode,
    });
    end();
  });
  next();
}

// GET /metrics — scraped by Prometheus / CloudWatch agent
router.get('/', async (_req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

module.exports = router;
module.exports.metricsMiddleware = metricsMiddleware;
