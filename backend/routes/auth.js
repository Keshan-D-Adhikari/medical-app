const express = require('express');
const { body } = require('express-validator');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/auth');
const rateLimit = require('../middleware/rateLimit');

const router = express.Router();

// Credential endpoints are the obvious brute-force target, so they get their
// own tighter budget than the rest of the API.
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  message: 'Too many login attempts, please try again in a few minutes',
});

const registerLimiter = rateLimit({
  windowMs: 60 * 60 * 1000,
  max: 20,
  message: 'Too many accounts created from this address, please try again later',
});

// Register route
router.post(
  '/register',
  registerLimiter,
  [
    body('firstName', 'First name is required').trim().notEmpty(),
    body('lastName', 'Last name is required').trim().notEmpty(),
    body('email', 'Please provide a valid email').isEmail().normalizeEmail(),
    body('password', 'Password must be at least 6 characters').isLength({ min: 6 }),
    body('phone', 'Please provide a valid phone number')
      .optional({ values: 'falsy' })
      .trim()
      .isLength({ min: 7, max: 20 }),
    body('role', 'Role must be patient or doctor').optional().isIn(['patient', 'doctor']),
  ],
  authController.register
);

// Login route
router.post(
  '/login',
  loginLimiter,
  [
    body('email', 'Please provide a valid email').isEmail().normalizeEmail(),
    body('password', 'Password is required').notEmpty(),
  ],
  authController.login
);

// Get current user route
router.get('/me', authMiddleware, authController.getCurrentUser);

module.exports = router;
