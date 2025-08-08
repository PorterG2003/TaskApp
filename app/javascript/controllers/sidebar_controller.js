import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "brandSection", "navSection", "userSection", "backdrop", "mobileHeader"]

  connect() {
    // Initialize sidebar state
    this.isOpen = window.innerWidth >= 1024 // Open by default on desktop
    this.updateSidebar()

    // Handle resize events
    this.resizeObserver = new ResizeObserver(entries => {
      const isDesktop = window.innerWidth >= 1024
      if (isDesktop && !this.isOpen) {
        this.open()
      } else if (!isDesktop && this.isOpen) {
        this.close()
      }
    })
    this.resizeObserver.observe(document.body)
  }

  disconnect() {
    this.resizeObserver.disconnect()
  }

  toggle() {
    if (this.isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.isOpen = true
    this.updateSidebar()
  }

  close() {
    this.isOpen = false
    this.updateSidebar()
  }

  updateSidebar() {
    if (this.isOpen) {
      this.expandSidebar()
    } else {
      this.collapseSidebar()
    }

    // Handle backdrop and mobile header
    if (this.hasBackdropTarget) {
      this.backdropTarget.classList.toggle('opacity-0', !this.isOpen)
      this.backdropTarget.classList.toggle('pointer-events-none', !this.isOpen)
    }
    if (this.hasMobileHeaderTarget) {
      this.mobileHeaderTarget.classList.toggle('hidden', this.isOpen)
    }
  }

  collapseSidebar() {
    this.sidebarTarget.classList.add('-translate-x-full')
    this.sidebarTarget.style.width = '16rem' // Keep full width but translate off-screen

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
        <a href="/calendar" class="text-gray-700 p-3 rounded-xl flex items-center justify-center transition duration-200 hover:bg-white/20" title="Calendar">
          <i class="fas fa-calendar-week text-lg"></i>
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
    this.sidebarTarget.classList.remove('-translate-x-full')
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
        <a href="/calendar" class="text-gray-700 px-4 py-3 rounded-xl flex items-center transition duration-200 hover:bg-white/20">
          <i class="fas fa-calendar-week text-lg mr-3"></i>
          <span class="font-medium">Calendar</span>
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