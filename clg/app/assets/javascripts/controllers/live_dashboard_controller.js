// Live Dashboard Monitoring
// This Stimulus controller handles real-time updates for patient monitoring

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["vitalsContainer", "mapContainer", "statusCards"]
  static values = { 
    refreshInterval: { type: Number, default: 30000 },
    autoRefresh: { type: Boolean, default: true }
  }
  
  connect() {
    console.log("Live monitoring dashboard connected")
    
    if (this.autoRefreshValue) {
      this.startAutoRefresh()
    }
    
    // Initialize connection status indicator
    this.updateConnectionStatus("connected")
  }
  
  disconnect() {
    this.stopAutoRefresh()
  }
  
  // Auto-refresh functionality
  startAutoRefresh() {
    this.refreshTimer = setInterval(() => {
      this.refreshAllData()
    }, this.refreshIntervalValue)
  }
  
  stopAutoRefresh() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
  
  // Refresh all dashboard data
  async refreshAllData() {
    try {
      this.updateConnectionStatus("refreshing")
      
      // Refresh vitals and locations in parallel
      await Promise.all([
        this.refreshVitalSigns(),
        this.refreshPatientLocations(),
        this.refreshDashboardStats()
      ])
      
      this.updateConnectionStatus("connected")
    } catch (error) {
      console.error("Error refreshing dashboard data:", error)
      this.updateConnectionStatus("error")
    }
  }
  
  // Refresh vital signs data
  async refreshVitalSigns() {
    try {
      const response = await fetch('/api/v1/vitals/latest', {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        }
      })
      
      if (response.ok) {
        const vitals = await response.json()
        this.updateVitalsDisplay(vitals)
      }
    } catch (error) {
      console.error("Error refreshing vital signs:", error)
    }
  }
  
  // Refresh patient locations
  async refreshPatientLocations() {
    try {
      const response = await fetch('/api/v1/patients/locations', {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        }
      })
      
      if (response.ok) {
        const locations = await response.json()
        this.updateLocationDisplay(locations)
      }
    } catch (error) {
      console.error("Error refreshing locations:", error)
    }
  }
  
  // Refresh dashboard statistics
  async refreshDashboardStats() {
    try {
      const response = await fetch('/api/v1/dashboard/stats', {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        }
      })
      
      if (response.ok) {
        const stats = await response.json()
        this.updateStatsDisplay(stats)
      }
    } catch (error) {
      console.error("Error refreshing stats:", error)
    }
  }
  
  // Update vital signs display
  updateVitalsDisplay(vitalsData) {
    vitalsData.forEach(vital => {
      const patientId = vital.patient_id
      
      // Update heart rate
      const heartRateEl = document.getElementById(`heartRate-${patientId}`)
      if (heartRateEl) heartRateEl.textContent = vital.heart_rate
      
      // Update blood pressure
      const bpEl = document.getElementById(`bloodPressure-${patientId}`)
      if (bpEl) bpEl.textContent = `${vital.blood_pressure_systolic}/${vital.blood_pressure_diastolic}`
      
      // Update temperature
      const tempEl = document.getElementById(`temperature-${patientId}`)
      if (tempEl) tempEl.textContent = `${vital.temperature}°F`
      
      // Update status badge
      const statusEl = document.getElementById(`vitalStatus-${patientId}`)
      if (statusEl) {
        statusEl.className = `badge bg-${vital.status_color}`
        statusEl.textContent = vital.status.charAt(0).toUpperCase() + vital.status.slice(1)
      }
      
      // Update timestamp
      const timestampEl = document.getElementById(`lastUpdate-${patientId}`)
      if (timestampEl) timestampEl.textContent = `Last update: ${vital.time_ago} ago`
    })
  }
  
  // Update location display (for map markers)
  updateLocationDisplay(locationsData) {
    // This would update map markers if map is initialized
    if (window.liveMap && window.patientMarkers) {
      locationsData.forEach(location => {
        const marker = window.patientMarkers[location.patient_id]
        if (marker) {
          // Update marker position
          marker.setLatLng([location.latitude, location.longitude])
          
          // Update marker style based on status
          const statusColors = {
            'safe': '#28a745',
            'away': '#ffc107', 
            'outside_zone': '#dc3545',
            'offline': '#6c757d'
          }
          
          marker.setStyle({
            fillColor: statusColors[location.status] || '#6c757d'
          })
          
          // Update popup content
          const popupContent = `
            <div class="text-center">
              <h6 class="mb-2">${location.name}</h6>
              <span class="badge bg-${this.getStatusBootstrapColor(location.status)}">
                ${location.status.replace('_', ' ').toUpperCase()}
              </span>
              <div class="small text-muted mt-1">
                Last seen: ${location.time_ago} ago
              </div>
            </div>
          `
          marker.setPopupContent(popupContent)
        }
      })
    }
  }
  
  // Update dashboard statistics
  updateStatsDisplay(statsData) {
    // Update stat cards if they exist
    const totalEl = document.querySelector('[data-stat="total-patients"]')
    if (totalEl) totalEl.textContent = statsData.total_patients
    
    const safeEl = document.querySelector('[data-stat="patients-safe"]')
    if (safeEl) safeEl.textContent = statsData.patients_in_safe_zones
    
    const alertsEl = document.querySelector('[data-stat="unread-alerts"]')
    if (alertsEl) alertsEl.textContent = statsData.unread_notifications
    
    const criticalEl = document.querySelector('[data-stat="critical-alerts"]')
    if (criticalEl) criticalEl.textContent = statsData.critical_alerts
  }
  
  // Update connection status indicator
  updateConnectionStatus(status) {
    const statusEl = document.getElementById('vitalsStatus')
    if (!statusEl) return
    
    const statusConfig = {
      connected: {
        class: 'badge bg-success',
        icon: 'bi-wifi',
        text: 'Connected'
      },
      refreshing: {
        class: 'badge bg-warning',
        icon: 'bi-arrow-clockwise spin',
        text: 'Updating...'
      },
      error: {
        class: 'badge bg-danger',
        icon: 'bi-wifi-off',
        text: 'Connection Error'
      }
    }
    
    const config = statusConfig[status] || statusConfig.connected
    statusEl.className = config.class
    statusEl.innerHTML = `<i class="${config.icon} me-1"></i>${config.text}`
  }
  
  // Manual refresh actions
  refreshVitals() {
    this.refreshVitalSigns()
  }
  
  refreshMap() {
    this.refreshPatientLocations()
  }
  
  // Helper methods
  getCSRFToken() {
    const token = document.querySelector('[name="csrf-token"]')
    return token ? token.content : ''
  }
  
  getStatusBootstrapColor(status) {
    const colorMap = {
      'safe': 'success',
      'away': 'warning', 
      'outside_zone': 'danger',
      'offline': 'secondary'
    }
    return colorMap[status] || 'secondary'
  }
}
