# Medical App Backend

A Node.js/Express backend for the Medical App with MongoDB integration.

## Features

- User authentication with JWT
- Patient profile management
- Doctor profile management
- MongoDB integration with Mongoose
- Input validation with express-validator
- Password hashing with bcryptjs
- CORS enabled for cross-origin requests

## Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or MongoDB Atlas)

## Installation

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file in the backend directory (already created with defaults):
```
MONGODB_URI=mongodb://localhost:27017/medical_app
PORT=8080
JWT_SECRET=your_jwt_secret_key_change_this_in_production
NODE_ENV=development
# Optional: comma-separated browser origins. Unset means "allow any origin",
# which is fine for local dev and native clients but not for a web deployment.
CORS_ORIGIN=http://localhost:3000
```

`MONGODB_URI` and `JWT_SECRET` are required — the server refuses to start
without them. When `NODE_ENV=production`, `JWT_SECRET` must also be at least
32 characters.

3. Update the MongoDB URI if using MongoDB Atlas:
```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/medical_app
```

## Running the Server

**Development mode (with auto-reload):**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

The server will start on `http://localhost:8080`

## API Endpoints

Authenticated routes expect `Authorization: Bearer <token>`.

### Authentication
- `POST /api/auth/register` - Register a new user. `role` may be `patient` or
  `doctor` only; `admin` cannot be self-assigned. Rate limited to 20/hour per IP.
- `POST /api/auth/login` - Login user. Rate limited to 10 per 15 minutes per IP.
- `GET /api/auth/me` - Get current user (requires token)

### Patients
Patient records are PHI and are never public.

- `POST /api/patients/profile` - Create patient profile (requires token)
- `GET /api/patients/profile` - Get own patient profile (requires token)
- `PUT /api/patients/profile` - Update own patient profile (requires token)
- `GET /api/patients` - List patients (**doctor or admin only**, paginated:
  `?page=1&limit=25`)
- `GET /api/patients/:id` - Get patient by ID (**own record, or doctor/admin**)

### Doctors
The doctor directory is public but exposes names only — no email or phone.

- `POST /api/doctors/profile` - Create doctor profile (**doctor or admin only**)
- `GET /api/doctors/profile` - Get own doctor profile (**doctor or admin only**)
- `PUT /api/doctors/profile` - Update own doctor profile (**doctor or admin only**;
  `licenseNumber` is immutable)
- `GET /api/doctors` - Public directory, paginated and filterable:
  `?specialization=Cardiology&page=1&limit=25`
- `GET /api/doctors/:id` - Get doctor by ID (public)

## MongoDB Setup

### Local MongoDB
1. Install MongoDB Community Edition from https://www.mongodb.com/try/download/community
2. Start MongoDB service
3. Update `.env` with local connection string

### MongoDB Atlas (Cloud)
1. Create account at https://www.mongodb.com/cloud/atlas
2. Create a cluster
3. Get connection string
4. Update `.env`:
```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/medical_app
```

## Project Structure

```
backend/
├── config/
│   └── database.js          # MongoDB connection
├── controllers/
│   ├── authController.js    # Authentication logic
│   ├── patientController.js # Patient management
│   └── doctorController.js  # Doctor management
├── middleware/
│   ├── auth.js              # JWT authentication + requireRole authorization
│   └── rateLimit.js         # dependency-free in-process rate limiter
├── models/
│   ├── User.js              # User schema
│   ├── Patient.js           # Patient schema
│   └── Doctor.js            # Doctor schema
├── routes/
│   ├── auth.js              # Auth routes
│   ├── patients.js          # Patient routes
│   └── doctors.js           # Doctor routes
├── .env                     # Environment variables
├── .gitignore               # Git ignore file
├── package.json             # Node dependencies
└── server.js                # Main server file
```
