<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Rails 8 Alzheimer's Patient Monitoring Application - Copilot Instructions

This is a Ruby on Rails 8 application designed for monitoring Alzheimer's patients. The application provides real-time tracking, vital signs monitoring, geofencing alerts, and caregiver management tools.

## Key Application Features

### Authentication & User Management
- Uses Devise for authentication with confirmable emails
- User profiles with caregiver information (name, phone, relationship to patient)
- Secure password reset and email confirmation

### Patient Management
- Complete CRUD operations for patient records
- Patient profiles include: name, age, gender, medical conditions
- Real-time location tracking with latitude/longitude coordinates
- Patient status indicators (safe, away, outside_zone, offline)

### Geofencing & Location Monitoring
- Create custom geofence zones with configurable radius
- Real-time alerts when patients leave safe zones
- Visual map display using Leaflet.js with zone overlays
- Distance calculations using Geocoder gem

### Vital Signs Tracking
- Heart rate, blood pressure, temperature monitoring
- Status classification (normal, warning, critical)
- Historical vital signs data with trends
- Alert generation for abnormal readings

### Activity Monitoring
- Track patient activities: walking, sitting, eating, medication, etc.
- Activity descriptions with timestamps and locations
- Recent activity feeds on dashboard

### Notifications & Alerts
- Real-time notification system for critical events
- Priority levels: low, medium, high, critical
- Types: geofence violations, vital signs alerts, activity alerts, system alerts
- Mark as read functionality with badges

### Dashboard & UI
- Bootstrap 5 responsive design with sidebar navigation
- Real-time dashboard with patient status overview
- Interactive maps with Leaflet.js integration
- Statistics cards showing key metrics
- Mobile-friendly responsive layout

## Technical Stack

### Backend
- Ruby on Rails 8.0
- SQLite3 database (development)
- Devise for authentication
- Geocoder for location services
- Faker for seed data

### Frontend
- Bootstrap 5 with Bootstrap Icons
- Leaflet.js for interactive maps
- Stimulus.js for JavaScript interactions
- Turbo for SPA-like navigation
- CSS bundling with Sass

### Models & Associations
- User: has_many patients, notifications
- Patient: belongs_to user, has_many vital_signs, geofence_zones, activities, notifications
- VitalSign: belongs_to patient
- GeofenceZone: belongs_to patient
- Activity: belongs_to patient
- Notification: belongs_to user, belongs_to patient (optional)

### Key Methods & Features
- Patient location status detection
- Geofence containment checking
- Vital signs status classification
- Real-time notification generation
- Time-based activity tracking

## Development Guidelines

When working on this application:

1. **Follow Rails conventions** - Use RESTful routes, proper MVC separation
2. **Maintain security** - Always use strong parameters, authenticate users
3. **Real-time features** - Consider ActionCable for WebSocket connections
4. **Responsive design** - Ensure mobile compatibility with Bootstrap
5. **Data validation** - Validate all model attributes appropriately
6. **Error handling** - Provide user-friendly error messages
7. **Testing** - Use RSpec for model and controller tests

## Common Patterns

### Controller Actions
- Always authenticate users with `before_action :authenticate_user!`
- Use `current_user.patients` to scope patient access
- Handle both HTML and JSON responses for AJAX requests
- Provide proper error handling and flash messages

### View Helpers
- Use Bootstrap classes for consistent styling
- Include status badges for patient conditions
- Show relative timestamps with `time_ago_in_words`
- Implement responsive layouts for mobile devices

### Model Logic
- Include status methods (e.g., `location_status`, `overall_status`)
- Use scopes for common queries (e.g., `recent`, `active`, `unread`)
- Implement distance calculations for geofencing
- Validate all required fields and associations

## Environment Setup

The application uses:
- Demo user: demo@patientmonitor.com / password123
- Seed data with sample patients, vital signs, activities, and notifications
- Development server runs on localhost:3000
- SQLite database for development simplicity
