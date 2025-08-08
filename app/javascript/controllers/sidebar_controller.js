import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "brandSection", "navSection", "userSection", "toggleIcon"]

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

    // Make the brand container match nav icon spacing/position
    this.brandSectionTarget.className = "px-2 py-2 border-b border-white/20 flex items-center justify-center"

    // Hamburger button styled like nav tab icons
    this.brandSectionTarget.innerHTML = `
      <button class="text-gray-700 p-3 rounded-xl flex items-center justify-center transition duration-200 hover:bg-white/20"
              data-action="click->sidebar#toggle" aria-label="Expand menu">
        <i class="fas fa-bars text-lg"></i>
      </button>
    `

    // Replace navigation with icons only (no background)
    this.navSectionTarget.innerHTML = `
      <nav class="flex-1 px-2 py-4 space-y-2">
        <a href="/tasks" class="text-gray-700 p-3 rounded-xl flex items-center justify-center transition duration-200 hover:bg-white/20" title="Tasks">
          <i class="fas fa-tasks text-lg"></i>
        </a>
        <a href="/tasks/new" class="text-gray-700 p-3 rounded-xl flex items-center justify-center transition duration-200 hover:bg-white/20" title="New Task">
          <i class="fas fa-plus text-lg"></i>
        </a>
        <a href="/components" class="text-gray-700 p-3 rounded-xl flex items-center justify-center transition duration-200 hover:bg-white/20" title="Components">
          <i class="fas fa-cube text-lg"></i>
        </a>
      </nav>
    `

    // Hide user section when collapsed
    this.userSectionTarget.style.display = 'none'
  }

  expandSidebar() {
    this.sidebarTarget.style.width = '16rem'

    // Restore brand container default classes
    this.brandSectionTarget.className = "p-6 border-b border-white/20 flex items-center justify-between"

    // Brand row with justify-between so elements are pushed to sides
    this.brandSectionTarget.innerHTML = `
      <a href="/tasks" class="flex items-center">
        <div class="w-10 h-10 glass-heavy bg-blue-600/80 backdrop-blur-xl rounded-xl flex items-center justify-center mr-3 border border-white/30">
          <i class="fas fa-tasks text-white text-lg"></i>
        </div>
        <span class="text-xl font-bold text-gray-900">TaskApp</span>
      </a>
      
      <button class="w-10 h-10 glass-medium bg-white/30 hover:bg-white/50 text-gray-700 rounded-xl transition duration-200 backdrop-blur-xl border border-white/30 flex items-center justify-center"
              data-action="click->sidebar#toggle" aria-label="Collapse menu">
        <i class="fa-solid fa-xmark text-xl"></i>
      </button>
    `

    // Restore navigation with text (no background on tabs)
    this.navSectionTarget.innerHTML = `
      <nav class="flex-1 px-4 py-6 space-y-2">
        <a href="/tasks" class="text-gray-700 px-4 py-3 rounded-xl flex items-center transition duration-200 hover:bg-white/20">
          <i class="fas fa-tasks text-lg mr-3"></i>
          <span class="font-medium">Tasks</span>
        </a>
        <a href="/tasks/new" class="text-gray-700 px-4 py-3 rounded-xl flex items-center transition duration-200 hover:bg-white/20">
          <i class="fas fa-plus text-lg mr-3"></i>
          <span class="font-medium">New Task</span>
        </a>
        <a href="/components" class="text-gray-700 px-4 py-3 rounded-xl flex items-center transition duration-200 hover:bg-white/20">
          <i class="fas fa-cube text-lg mr-3"></i>
          <span class="font-medium">Components</span>
        </a>
      </nav>
    `

    // Show user section when expanded
    this.userSectionTarget.style.display = 'block'
  }

  onTransitionEnd() {
    // Handle any cleanup after transition completes
  }
} 