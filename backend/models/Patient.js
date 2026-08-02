const mongoose = require('mongoose');

const patientSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    age: {
      type: Number,
    },
    bloodType: {
      type: String,
      enum: ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'],
    },
    medicalHistory: {
      type: String,
    },
    allergies: {
      type: String,
    },
    currentMedications: {
      type: String,
    },
    emergencyContact: {
      name: String,
      phone: String,
      relation: String,
    },
    appointments: [
      {
        doctorId: mongoose.Schema.Types.ObjectId,
        date: Date,
        reason: String,
        status: {
          type: String,
          enum: ['scheduled', 'completed', 'cancelled'],
          default: 'scheduled',
        },
      },
    ],
  },
  { timestamps: true }
);

module.exports = mongoose.model('Patient', patientSchema);
