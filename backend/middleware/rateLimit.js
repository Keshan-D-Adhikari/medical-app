// Minimal in-process rate limiter. Deliberately dependency-free so the backend
// keeps its current package.json. If this ever runs behind more than one node
// process, swap it for express-rate-limit backed by Redis — the counters below
// are per-process and reset on restart.

const buckets = new Map();

const rateLimit = ({ windowMs = 15 * 60 * 1000, max = 10, message } = {}) => {
  return (req, res, next) => {
    const key = `${req.ip}:${req.baseUrl}${req.path}`;
    const now = Date.now();
    const bucket = buckets.get(key);

    if (!bucket || now > bucket.resetAt) {
      buckets.set(key, { count: 1, resetAt: now + windowMs });
      return next();
    }

    bucket.count += 1;

    if (bucket.count > max) {
      const retryAfter = Math.ceil((bucket.resetAt - now) / 1000);
      res.set('Retry-After', String(retryAfter));
      return res.status(429).json({
        message: message || 'Too many requests, please try again later',
        retryAfter,
      });
    }

    next();
  };
};

// Drop expired buckets so the map does not grow without bound.
const sweeper = setInterval(() => {
  const now = Date.now();
  for (const [key, bucket] of buckets) {
    if (now > bucket.resetAt) {
      buckets.delete(key);
    }
  }
}, 5 * 60 * 1000);

sweeper.unref();

module.exports = rateLimit;
