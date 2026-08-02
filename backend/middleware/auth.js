const jwt = require('jsonwebtoken');
const User = require('../models/User');

const authMiddleware = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      return res.status(401).json({ message: 'No token provided' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // A token stays valid for 7 days, so re-check the account is still enabled
    // instead of trusting the claims alone.
    const user = await User.findById(decoded.id).select('role isActive');
    if (!user || !user.isActive) {
      return res.status(401).json({ message: 'Account is no longer active' });
    }

    req.user = { id: decoded.id, email: decoded.email, role: user.role };
    next();
  } catch (error) {
    res.status(401).json({ message: 'Invalid token' });
  }
};

// Restricts a route to the given roles. Must run after authMiddleware.
const requireRole = (...roles) => (req, res, next) => {
  if (!req.user) {
    return res.status(401).json({ message: 'Not authenticated' });
  }

  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ message: 'Insufficient permissions' });
  }

  next();
};

module.exports = authMiddleware;
module.exports.authMiddleware = authMiddleware;
module.exports.requireRole = requireRole;
