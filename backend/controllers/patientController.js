const Patient = require('../models/Patient');
const { validationResult } = require('express-validator');

// Fields safe to expose from the linked User document.
const USER_FIELDS = 'firstName lastName email phone role';

// Create patient profile
exports.createPatientProfile = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { age, bloodType, medicalHistory, allergies, currentMedications } = req.body;

    let patient = await Patient.findOne({ userId: req.user.id });
    if (patient) {
      return res.status(400).json({ message: 'Patient profile already exists' });
    }

    patient = new Patient({
      userId: req.user.id,
      age,
      bloodType,
      medicalHistory,
      allergies,
      currentMedications,
    });

    await patient.save();
    res.status(201).json({ message: 'Patient profile created', patient });
  } catch (error) {
    next(error);
  }
};

// Get patient profile
exports.getPatientProfile = async (req, res, next) => {
  try {
    const patient = await Patient.findOne({ userId: req.user.id }).populate('userId', USER_FIELDS);
    if (!patient) {
      return res.status(404).json({ message: 'Patient profile not found' });
    }
    res.status(200).json({ patient });
  } catch (error) {
    next(error);
  }
};

// Update patient profile
exports.updatePatientProfile = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { age, bloodType, medicalHistory, allergies, currentMedications, emergencyContact } = req.body;

    const patient = await Patient.findOne({ userId: req.user.id });
    if (!patient) {
      return res.status(404).json({ message: 'Patient profile not found' });
    }

    // `!== undefined` rather than truthiness, so a deliberate 0 or "" is not
    // silently ignored (e.g. clearing an allergy list).
    if (age !== undefined) patient.age = age;
    if (bloodType !== undefined) patient.bloodType = bloodType;
    if (medicalHistory !== undefined) patient.medicalHistory = medicalHistory;
    if (allergies !== undefined) patient.allergies = allergies;
    if (currentMedications !== undefined) patient.currentMedications = currentMedications;
    if (emergencyContact !== undefined) patient.emergencyContact = emergencyContact;

    await patient.save();
    res.status(200).json({ message: 'Patient profile updated', patient });
  } catch (error) {
    next(error);
  }
};

// Get all patients (staff only — enforced by requireRole on the route)
exports.getAllPatients = async (req, res, next) => {
  try {
    const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
    const limit = Math.min(Math.max(parseInt(req.query.limit, 10) || 25, 1), 100);

    const [patients, total] = await Promise.all([
      Patient.find()
        .populate('userId', USER_FIELDS)
        .skip((page - 1) * limit)
        .limit(limit),
      Patient.countDocuments(),
    ]);

    res.status(200).json({ patients, page, limit, total });
  } catch (error) {
    next(error);
  }
};

// Get patient by ID — own record, or staff
exports.getPatientById = async (req, res, next) => {
  try {
    const patient = await Patient.findById(req.params.id).populate('userId', USER_FIELDS);
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    const isStaff = req.user.role === 'doctor' || req.user.role === 'admin';
    const isOwner = String(patient.userId?._id ?? patient.userId) === String(req.user.id);

    if (!isStaff && !isOwner) {
      return res.status(403).json({ message: 'Insufficient permissions' });
    }

    res.status(200).json({ patient });
  } catch (error) {
    next(error);
  }
};
