const Doctor = require('../models/Doctor');
const { validationResult } = require('express-validator');

// Fields safe to expose from the linked User document.
const USER_FIELDS = 'firstName lastName email phone role';
// The public directory does not need contact details.
const PUBLIC_USER_FIELDS = 'firstName lastName';

// Create doctor profile
exports.createDoctorProfile = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { specialization, licenseNumber, hospital, experience, consultationFee, availableSlots } = req.body;

    let doctor = await Doctor.findOne({ userId: req.user.id });
    if (doctor) {
      return res.status(400).json({ message: 'Doctor profile already exists' });
    }

    if (await Doctor.exists({ licenseNumber })) {
      return res.status(400).json({ message: 'License number is already registered' });
    }

    doctor = new Doctor({
      userId: req.user.id,
      specialization,
      licenseNumber,
      hospital,
      experience,
      consultationFee,
      availableSlots,
    });

    await doctor.save();
    res.status(201).json({ message: 'Doctor profile created', doctor });
  } catch (error) {
    next(error);
  }
};

// Get doctor profile
exports.getDoctorProfile = async (req, res, next) => {
  try {
    const doctor = await Doctor.findOne({ userId: req.user.id }).populate('userId', USER_FIELDS);
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor profile not found' });
    }
    res.status(200).json({ doctor });
  } catch (error) {
    next(error);
  }
};

// Get all doctors — public directory, optionally filtered by specialization
exports.getAllDoctors = async (req, res, next) => {
  try {
    const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
    const limit = Math.min(Math.max(parseInt(req.query.limit, 10) || 25, 1), 100);

    const filter = {};
    if (req.query.specialization) {
      // Escape the input before it reaches the regex engine.
      const escaped = String(req.query.specialization).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      filter.specialization = new RegExp(`^${escaped}$`, 'i');
    }

    const [doctors, total] = await Promise.all([
      Doctor.find(filter)
        .select('-patients')
        .populate('userId', PUBLIC_USER_FIELDS)
        .skip((page - 1) * limit)
        .limit(limit),
      Doctor.countDocuments(filter),
    ]);

    res.status(200).json({ doctors, page, limit, total });
  } catch (error) {
    next(error);
  }
};

// Get doctor by ID — public directory
exports.getDoctorById = async (req, res, next) => {
  try {
    const doctor = await Doctor.findById(req.params.id)
      .select('-patients')
      .populate('userId', PUBLIC_USER_FIELDS);
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.status(200).json({ doctor });
  } catch (error) {
    next(error);
  }
};

// Update doctor profile
exports.updateDoctorProfile = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { specialization, hospital, experience, consultationFee, availableSlots } = req.body;

    const doctor = await Doctor.findOne({ userId: req.user.id });
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor profile not found' });
    }

    // licenseNumber is intentionally not updatable here.
    if (specialization !== undefined) doctor.specialization = specialization;
    if (hospital !== undefined) doctor.hospital = hospital;
    if (experience !== undefined) doctor.experience = experience;
    if (consultationFee !== undefined) doctor.consultationFee = consultationFee;
    if (availableSlots !== undefined) doctor.availableSlots = availableSlots;

    await doctor.save();
    res.status(200).json({ message: 'Doctor profile updated', doctor });
  } catch (error) {
    next(error);
  }
};
