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
    const isDesktop = window.innerWidth >= 1024

    if (this.isOpen) {
      this.expandSidebar()
    } else {
      this.collapseSidebar(isDesktop)
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

  collapseSidebar(isDesktop) {
    if (isDesktop) {
      // Desktop collapsed state
      this.sidebarTarget.style.width = '4rem'
      this.sidebarTarget.classList.remove('-translate-x-full')
      
      // Minimal brand section
      this.brandSectionTarget.className = "p-2 border-b border-white/20 flex items-center justify-center"
      this.brandSectionTarget.innerHTML = `
        <button class="glass-medium bg-white/30 hover:bg-white/50 text-gray-700 w-10 h-10 rounded-xl transition duration-200 backdrop-blur-xl border border-white/30 flex items-center justify-center"
                data-action="click->sidebar#toggle" aria-label="Expand menu">
          <i class="fas fa-bars text-lg"></i>
        </button>
      `
    } else {
      // Mobile collapsed state
      this.sidebarTarget.style.width = '16rem'
      this.sidebarTarget.classList.add('-translate-x-full')
    }

    // Icons-only navigation
    this.navSectionTarget.innerHTML = `
      <nav class="flex-1 px-2 py-4 space-y-2">
        <a href="/tasks" class="text-gray-700 p-3 rounded-xl flex items-center justify-center transition duration-200 hover:bg-white/20" title="Tasks">
          <i class="fas fa-tasks text-lg"></i>
        </a>
        <a href="/calendar" class="text-gray-700 p-3 rounded-xl flex items-center justify-center transition duration-200 hover:bg-white/20" title="Calendar">
          <i class="fas fa-calendar-week text-lg"></i>
        </a>
      </nav>
    `

    // Hide user section
    this.userSectionTarget.style.display = 'none'
  }

  expandSidebar() {
    this.sidebarTarget.style.width = '16rem'
    this.sidebarTarget.classList.remove('-translate-x-full')

    // Full brand section
    this.brandSectionTarget.className = "p-6 border-b border-white/20 flex items-center justify-between"
    this.brandSectionTarget.innerHTML = `
      <a href="/tasks" class="flex items-center">
        <div class="w-10 h-10 glass-heavy bg-blue-600/80 backdrop-blur-xl rounded-xl flex items-center justify-center mr-3 border border-white/30">
          <i class="fas fa-tasks text-gray-900 text-lg"></i>
        </div>
        <span class="text-xl font-bold text-gray-900">TaskApp</span>
      </a>
      
      <button class="w-10 h-10 glass-medium bg-white/30 hover:bg-white/50 text-gray-700 rounded-xl transition duration-200 backdrop-blur-xl border border-white/30 flex items-center justify-center"
              data-action="click->sidebar#toggle" aria-label="Collapse menu">
        <i class="fas fa-times text-xl"></i>
      </button>
    `

    // Full navigation with text
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
      </nav>
    `

    // Show user section
    this.userSectionTarget.style.display = 'block'
  }

  onTransitionEnd() {
    // Handle any cleanup after transition completes
  }
}