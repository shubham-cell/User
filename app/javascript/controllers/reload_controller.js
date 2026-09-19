import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { interval: { type: Number, default: 3000 } }

  connect() {
    this.timer = setTimeout(() => window.location.reload(), this.intervalValue)
  }

  disconnect() {
    clearTimeout(this.timer)
  }
}
