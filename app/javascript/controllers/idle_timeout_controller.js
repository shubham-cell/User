import { Controller } from "@hotwired/stimulus"

const TOKEN_KEY = "auth_token"

// Ends the session after a period of no user activity in the browser.
export default class extends Controller {
  static values = {
    seconds: { type: Number, default: 3600 },
    logoutUrl: { type: String, default: "/logout" }
  }

  connect() {
    this.events = ["mousemove", "mousedown", "keydown", "touchstart", "scroll", "click"]
    this.resetTimer = this.resetTimer.bind(this)
    this.events.forEach((event) => window.addEventListener(event, this.resetTimer, { passive: true }))
    this.resetTimer()
  }

  disconnect() {
    this.clearTimer()
    this.events.forEach((event) => window.removeEventListener(event, this.resetTimer))
  }

  resetTimer() {
    this.clearTimer()
    this.timer = window.setTimeout(() => this.logout(), this.secondsValue * 1000)
  }

  clearTimer() {
    if (this.timer) window.clearTimeout(this.timer)
  }

  async logout() {
    const token = sessionStorage.getItem(TOKEN_KEY)
    const csrf = document.querySelector("meta[name='csrf-token']")?.content
    const url = new URL(this.logoutUrlValue, window.location.origin)

    try {
      await fetch(url.toString(), {
        method: "GET",
        headers: {
          Accept: "application/json",
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
          ...(csrf ? { "X-CSRF-Token": csrf } : {})
        }
      })
    } finally {
      sessionStorage.removeItem(TOKEN_KEY)
      window.location.href = "/login"
    }
  }
}
