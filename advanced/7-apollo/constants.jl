const ME = 5.97e24 # mass of earth in kg
const RE = 6.378e6 # radius of earth in m (at equator)
const G = 6.67e-11 # gravitational constant in m3 / kg s2
const MM = 7.35e22 # mass of moon in kg
const RM = 1.74e6 # radius of moon in m
const MCM = 5000. # mass of command module in kg
const DISTANCE_TO_MOON = 400.5e6 # m (actually, not at all a constant)
const MOON_PERIOD = 27.3 * 24.0 * 3600. # s
const MOON_INITIAL_ANGLE = pi / 180. * -61. # radians
const ORIGIN = [0., 0.] # Vector that represents the origin

const TOTAL_DURATION = 12. * 24. * 3600.# s
const MARKER_TIME = 0.5 * 3600. # (used in error correction) s
const TOLERANCE = 100000. # (used in error correction) m

const INITIAL_POSITION = [-6.701e6, 0.] # Initial vector for the spacecraft in m
const INITIAL_VELOCITY = [0., -10.818e3] # Initial velocity for spacecraft in m/s