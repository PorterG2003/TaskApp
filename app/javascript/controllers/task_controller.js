import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    // Form will be submitted via Turbo automatically
    // This method can be used for additional UI feedback if needed
    const checkbox = event.target.closest('form').querySelector('input[type="hidden"]')
    const taskCard = this.element
    
    if (checkbox.value === 'true') {
      // Task will be marked as completed
      taskCard.style.opacity = '0.7'
    } else {
      // Task will be marked as incomplete
      taskCard.style.opacity = '1'
    }
  }
}