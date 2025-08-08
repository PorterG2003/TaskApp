import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "brandText", "navText", "userInfo", "toggleIcon", "navIcon"]

  connect() {
    // Initialize sidebar state from localStorage or default to expanded
    this.isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true'
    this.updateSidebar()
  }

  toggle() {
    this.isCollapsed = !this.isCollapsed
    localStorage.setItem('sidebarCollapsed', this.isCollapsed)
    this.updateSidebar()
  }

  updateSidebar() {
    if (this.isCollapsed) {
      this.collapseSidebar()
    } else {
      this.expandSidebar()
    }
  }

  collapseSidebar() {
    this.sidebarTarget.style.width = '4rem'
    this.brandTextTarget.style.opacity = '0'
    this.navTextTargets.forEach(text => text.style.opacity = '0')
    this.userInfoTarget.style.opacity = '0'
    this.toggleIconTarget.innerHTML = `
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
    `
    
    // Add tooltips to navigation items when collapsed
    this.navIconTargets.forEach((icon, index) => {
      const parent = icon.closest('a')
      if (parent) {
        const tooltips = ['Tasks', 'New Task', 'Components']
        parent.setAttribute('title', tooltips[index] || 'Navigation')
      }
    })
  }

  expandSidebar() {
    this.sidebarTarget.style.width = '16rem'
    this.brandTextTarget.style.opacity = '1'
    this.navTextTargets.forEach(text => text.style.opacity = '1')
    this.userInfoTarget.style.opacity = '1'
    this.toggleIconTarget.innerHTML = `
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
    `
    
    // Remove tooltips when expanded
    this.navIconTargets.forEach(icon => {
      const parent = icon.closest('a')
      if (parent) {
        parent.removeAttribute('title')
      }
    })
  }

  onTransitionEnd() {
    // Handle any cleanup after transition completes
  }
} 