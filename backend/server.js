require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/database');

// Fail fast rather than signing tokens with `undefined`.
const REQUIRED_ENV = ['MONGODB_URI', 'JWT_SECRET'];
const missing = REQUIRED_ENV.filter((key) => !process.env[key]);
if (missing.length) {
  console.error(`Missing required environment variables: ${missing.join(', ')}`);
  process.exit(1);
}

const isProduction = process.env.NODE_ENV === 'production';

if (isProduction && process.env.JWT_SECRET.length < 32) {
  console.error('JWT_SECRET must be at least 32 characters in production');
  process.exit(1);
}

// Connect to MongoDB
connectDB();

const app = express();

// Middleware
// CORS_ORIGIN is a comma-separated allowlist. Left unset, any origin is
// allowed — fine for local development and native clients, not for a
// browser-facing deployment.
const allowedOrigins = (process.env.CORS_ORIGIN || '')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);

app.use(
  cors(
    allowedOrigins.length
      ? { origin: allowedOrigins, credentials: true }
      : undefined
  )
);
app.use(express.json({ limit: '100kb' }));

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/patients', require('./routes/patients'));
app.use('/api/doctors', require('./routes/doctors'));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ message: 'Server is running' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ message: 'Route not found' });
});

// Error handler
// eslint-disable-next-line no-unused-vars
app.use((error, req, res, next) => {
  console.error(error);

  // Surface the two client-fixable Mongoose failures; everything else is opaque.
  if (error.name === 'ValidationError') {
    return res.status(400).json({ message: 'Validation failed' });
  }
  if (error.name === 'CastError') {
    return res.status(400).json({ message: 'Malformed identifier' });
  }
  if (error.code === 11000) {
    return res.status(409).json({ message: 'Duplicate value' });
  }

  // Internal details stay in the logs, not in the response body.
  res.status(500).json({
    message: 'Internal server error',
    ...(isProduction ? {} : { error: error.message }),
  });
});

const PORT = process.env.PORT || 8080;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
