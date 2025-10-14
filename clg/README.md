# Alzheimer's Patient Monitoring Application

A comprehensive Ruby on Rails 8 web application designed to help caregivers monitor Alzheimer's patients in real-time. The application provides location tracking, vital signs monitoring, geofencing alerts, and activity monitoring with a modern, responsive Bootstrap interface.

![Rails Version](https://img.shields.io/badge/Rails-8.0-red.svg)
![Ruby Version](https://img.shields.io/badge/Ruby-3.2+-red.svg)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5-purple.svg)

## 🚀 Features

### 🔐 Authentication & User Management
- Secure user registration and login with Devise
- Email confirmation and password reset functionality
- User profiles with caregiver information (name, phone, relationship to patient)

### 👥 Patient Dashboard
- **Real-time Patient Overview**: Central dashboard showing live patient data
- **Interactive Location Maps**: Live patient location tracking using Leaflet.js
- **Status Indicators**: Visual indicators for patient safety (safe, away, outside zone, offline)
- **Vital Signs Monitoring**: Heart rate, blood pressure, and temperature tracking
- **Activity Timeline**: Latest patient activities (walking, resting, medication, etc.)

### 🗺️ Geofencing & Location Alerts
- **Custom Safe Zones**: Define circular geofence areas around important locations
- **Automatic Alerts**: Real-time notifications when patients leave designated safe zones
- **Visual Zone Display**: Interactive maps showing geofence boundaries and patient locations
- **Distance Calculations**: Precise location monitoring using coordinate mathematics

### 📊 Health Monitoring
- **Vital Signs Tracking**: Monitor heart rate, blood pressure, and temperature
- **Health Status Classification**: Automatic categorization (normal, warning, critical)
- **Historical Data**: Track vital signs trends over time
- **Alert Generation**: Automatic notifications for abnormal readings

### 🔔 Advanced Notification System
- **Real-time Alerts**: Instant notifications for critical events
- **Priority Levels**: Low, medium, high, and critical priority classifications
- **Multiple Alert Types**: Geofence violations, vital signs alerts, activity alerts, system notifications
- **Notification Management**: Mark as read, notification history, and filtering

### 📱 Modern UI/UX
- **Responsive Design**: Bootstrap 5 interface that works on desktop, tablet, and mobile
- **Sidebar Navigation**: Clean, professional layout with easy navigation
- **Interactive Maps**: Leaflet.js integration for smooth map interactions
- **Real-time Updates**: Live dashboard updates without page refresh
- **Mobile-First**: Optimized for caregivers on the go

## 🛠️ Technical Stack

### Backend
- **Ruby on Rails 8.0**: Latest Rails framework with modern features
- **SQLite3**: Lightweight database for development
- **Devise**: Robust authentication and user management
- **Geocoder**: Location services and distance calculations
- **Faker**: Realistic seed data generation

### Frontend  
- **Bootstrap 5**: Modern CSS framework with responsive components
- **Bootstrap Icons**: Comprehensive icon library
- **Leaflet.js**: Interactive map library for location visualization
- **Stimulus.js**: Lightweight JavaScript framework
- **Turbo**: Fast, SPA-like navigation
- **Sass**: CSS preprocessing for maintainable stylesheets

### Architecture
- **MVC Pattern**: Clean separation of concerns
- **RESTful Routes**: Standard Rails routing conventions
- **Responsive Design**: Mobile-first approach
- **Real-time Ready**: Prepared for ActionCable WebSocket integration

## 🏁 Quick Start

### Prerequisites
- Ruby 3.2.0 or higher
- Rails 8.0
- Node.js and Yarn (for asset compilation)
- SQLite3

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd alzheimer-patient-monitor
   ```

2. **Install dependencies**
   ```bash
   bundle install
   yarn install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Visit the application**
   ```
   http://localhost:3000
   ```

### Demo Access
```
Email: demo@patientmonitor.com
Password: password123
```

## 📋 Usage Guide

### Getting Started
1. **Login** with the demo credentials or create a new account
2. **Add Patients** using the "Add Patient" button on the dashboard
3. **Set Location** using the GPS coordinates or current location
4. **Create Geofences** to define safe zones around important locations
5. **Monitor Dashboard** for real-time patient status and alerts

### Key Features Walkthrough

#### Dashboard Overview
- View all patients at a glance with status indicators
- Monitor recent vital signs and activities
- Check unread notifications and critical alerts
- Access quick statistics on patient safety

#### Patient Management
- Add new patients with complete medical information
- Update patient details and location coordinates
- View detailed patient profiles with maps and history
- Track patient activities and health metrics

#### Geofencing Setup
- Create custom safe zones with adjustable radius
- Set up multiple zones per patient (home, neighborhood, etc.)
- Receive automatic alerts for zone violations
- Visualize zones on interactive maps

#### Notification Management
- View all notifications with priority filtering
- Mark notifications as read/unread
- Receive alerts for various events (location, health, activity)
- Access detailed notification history

## 🏗️ Project Structure

```
app/
├── controllers/          # Application controllers
│   ├── dashboard_controller.rb
│   ├── patients_controller.rb
│   ├── notifications_controller.rb
│   └── ...
├── models/              # Data models and business logic
│   ├── user.rb          # Caregiver/user model
│   ├── patient.rb       # Patient model with location logic
│   ├── vital_sign.rb    # Health monitoring
│   ├── geofence_zone.rb # Location boundaries
│   └── ...
├── views/               # ERB templates
│   ├── layouts/         # Application layout with Bootstrap
│   ├── dashboard/       # Dashboard views
│   ├── patients/        # Patient management views
│   └── ...
└── assets/
    ├── stylesheets/     # Sass/CSS files
    └── javascripts/     # Stimulus controllers
```

## 🔧 Configuration

### Environment Variables
The application uses standard Rails configuration. For production deployment, configure:

- `SECRET_KEY_BASE`: Rails secret key
- `DATABASE_URL`: Production database connection
- Email delivery settings for Devise confirmations

### Database Configuration
Development uses SQLite3 by default. For production, update `config/database.yml`:

```yaml
production:
  adapter: postgresql
  url: <%= ENV['DATABASE_URL'] %>
```

## 🧪 Testing

The application includes RSpec test suite:

```bash
# Run all tests
bundle exec rspec

# Run specific test types
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/
```

### Test Coverage
- Model validations and associations
- Controller actions and authentication
- View rendering and form submissions
- Business logic for geofencing and health monitoring

## 🚀 Deployment

### Production Checklist
- [ ] Configure production database (PostgreSQL recommended)
- [ ] Set up email delivery for Devise notifications
- [ ] Configure secret keys and environment variables
- [ ] Set up SSL/HTTPS for secure authentication
- [ ] Configure background job processing for real-time features
- [ ] Set up monitoring and logging

### Deployment Platforms
The application is ready for deployment on:
- **Heroku**: Easy Rails deployment with add-ons
- **Railway**: Modern deployment platform
- **DigitalOcean App Platform**: Scalable cloud deployment
- **Traditional VPS**: Ubuntu/CentOS with Passenger or Puma

## 🔄 Future Enhancements

### Planned Features
- **Real-time WebSocket Updates**: ActionCable integration for live dashboard updates
- **Mobile App Integration**: REST API for companion mobile applications
- **Advanced Analytics**: Patient behavior patterns and health trend analysis
- **Multi-tenant Support**: Support for multiple caregiver organizations
- **Integration APIs**: Connect with medical devices and health monitoring systems
- **Advanced Mapping**: Routing, traffic data, and location prediction
- **Medication Reminders**: Automated medication scheduling and alerts
- **Emergency Contacts**: Automatic emergency contact notification system

### Technical Improvements
- **Performance Optimization**: Database indexing and query optimization
- **Caching Layer**: Redis caching for frequently accessed data
- **Background Jobs**: Sidekiq for processing alerts and notifications
- **API Documentation**: Comprehensive REST API documentation
- **Monitoring**: Application performance monitoring and error tracking

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes** following Rails conventions
4. **Add tests** for new functionality
5. **Commit changes** (`git commit -m 'Add amazing feature'`)
6. **Push to branch** (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

### Development Guidelines
- Follow Rails conventions and best practices
- Write comprehensive tests for new features
- Maintain responsive design principles
- Use semantic commit messages
- Update documentation for significant changes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🆘 Support

For support and questions:
- **Issues**: Create a GitHub issue for bug reports
- **Documentation**: Check the wiki for detailed guides
- **Community**: Join our discussions for feature requests

---

**Built with ❤️ for caregivers and families managing Alzheimer's care**
