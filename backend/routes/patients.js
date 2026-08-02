const express = require('express');
const { body } = require('express-validator');
const patientController = require('../controllers/patientController');
const authMiddleware = require('../middleware/auth');
const { requireRole } = require('../middleware/auth');

const router = express.Router();

const profileValidators = [
  body('age', 'Age must be between 0 and 130').optional().isInt({ min: 0, max: 130 }),
  body('bloodType', 'Invalid blood type')
    .optional()
    .isIn(['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-']),
  body('medicalHistory').optional().isString().trim().isLength({ max: 5000 }),
  body('allergies').optional().isString().trim().isLength({ max: 2000 }),
  body('currentMedications').optional().isString().trim().isLength({ max: 2000 }),
  body('emergencyContact.name').optional().isString().trim().isLength({ max: 120 }),
  body('emergencyContact.phone').optional().isString().trim().isLength({ max: 40 }),
  body('emergencyContact.relation').optional().isString().trim().isLength({ max: 60 }),
];

// Create patient profile
router.post('/profile', authMiddleware, profileValidators, patientController.createPatientProfile);

// Get patient profile
router.get('/profile', authMiddleware, patientController.getPatientProfile);

// Update patient profile
router.put('/profile', authMiddleware, profileValidators, patientController.updatePatientProfile);

// Get all patients — patient records are PHI, so staff only.
router.get('/', authMiddleware, requireRole('doctor', 'admin'), patientController.getAllPatients);

// Get patient by ID — a patient may read their own record; staff may read any.
router.get('/:id', authMiddleware, patientController.getPatientById);

module.exports = router;
