const express = require('express');
const { body } = require('express-validator');
const doctorController = require('../controllers/doctorController');
const authMiddleware = require('../middleware/auth');
const { requireRole } = require('../middleware/auth');

const router = express.Router();

const profileValidators = [
  body('specialization', 'Specialization is required').optional().isString().trim().notEmpty(),
  body('hospital').optional().isString().trim().isLength({ max: 200 }),
  body('experience', 'Experience must be between 0 and 80 years')
    .optional()
    .isInt({ min: 0, max: 80 }),
  body('consultationFee', 'Consultation fee must be a positive number')
    .optional()
    .isFloat({ min: 0 }),
  body('availableSlots').optional().isArray(),
  body('availableSlots.*.day').optional().isString().trim().notEmpty(),
  body('availableSlots.*.startTime').optional().isString().trim().notEmpty(),
  body('availableSlots.*.endTime').optional().isString().trim().notEmpty(),
];

// Create doctor profile — only accounts registered as doctors.
router.post(
  '/profile',
  authMiddleware,
  requireRole('doctor', 'admin'),
  [
    body('specialization', 'Specialization is required').isString().trim().notEmpty(),
    body('licenseNumber', 'License number is required').isString().trim().notEmpty(),
    ...profileValidators,
  ],
  doctorController.createDoctorProfile
);

// Get doctor profile
router.get('/profile', authMiddleware, requireRole('doctor', 'admin'), doctorController.getDoctorProfile);

// Update doctor profile
router.put(
  '/profile',
  authMiddleware,
  requireRole('doctor', 'admin'),
  profileValidators,
  doctorController.updateDoctorProfile
);

// Get all doctors — public directory, deliberately unauthenticated.
router.get('/', doctorController.getAllDoctors);

// Get doctor by ID — public directory.
router.get('/:id', doctorController.getDoctorById);

module.exports = router;
