// DAWActivityLogger.js
// No-op stub for activity logging
// This is a placeholder implementation that does nothing
// Used when CPR-specific logging is not needed

class DAWActivityLogger {
  constructor() {
    this.isActive = false;
  }

  startSession(config = {}) {
    // No-op: does nothing
  }

  switchMode(mode) {
    // No-op: does nothing
  }

  logUndo() {
    // No-op: does nothing
  }

  logRedo() {
    // No-op: does nothing
  }

  toCompressedString() {
    return '';
  }
}

// Singleton instance
let instance = null;

export function getDAWActivityLogger() {
  if (!instance) {
    instance = new DAWActivityLogger();
  }
  return instance;
}

export default DAWActivityLogger;
