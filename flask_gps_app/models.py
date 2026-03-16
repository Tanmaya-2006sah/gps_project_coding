from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(128), nullable=False)
    patients = db.relationship('Patient', backref='guardian', lazy=True)

class Patient(db.Model):
    __tablename__ = 'patients'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    guardian_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    health_data = db.relationship('HealthData', backref='patient', lazy=True)

class Guardian(db.Model):
    __tablename__ = 'guardians'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    relation = db.Column(db.String(50), nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)

class Location(db.Model):
    __tablename__ = 'locations'
    id = db.Column(db.Integer, primary_key=True)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)

class HealthData(db.Model):
    __tablename__ = 'health_data'
    id = db.Column(db.Integer, primary_key=True)
    heart_rate = db.Column(db.Integer)
    blood_pressure = db.Column(db.String(50))
    temperature = db.Column(db.Float)
    timestamp = db.Column(db.DateTime, nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)

class GeofenceAlert(db.Model):
    __tablename__ = 'geofence_alerts'
    id = db.Column(db.Integer, primary_key=True)
    alert_type = db.Column(db.String(50), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey('patients.id'), nullable=False)