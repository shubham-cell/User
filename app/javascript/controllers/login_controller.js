import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

const TOKEN_KEY = "auth_token"

// Login via JSON and store the Bearer token for later requests.
export default class extends Controller {
  static targets = ["email", "password", "error"]
  static values = { url: { type: String, default: "/login" } }

  async submit(event) {
    event.preventDefault()
    event.stopPropagation()

    if (this.hasErrorTarget) {
      this.errorTarget.hidden = true
      this.errorTarget.textContent = ""
    }

    const body = new FormData()
    body.append("email", this.emailTarget.value)
    body.append("password", this.passwordTarget.value)
    body.append("authenticity_token", document.querySelector("meta[name='csrf-token']")?.content || "")

    const response = await fetch(this.urlValue, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content
      },
      body,
      credentials: "same-origin"
    })

    const data = await response.json().catch(() => ({}))

    if (!response.ok) {
      if (this.hasErrorTarget) {
        this.errorTarget.hidden = false
        this.errorTarget.textContent = data.error || "Invalid email or password"
      }
      return
    }

    if (!data.token) {
      if (this.hasErrorTarget) {
        this.errorTarget.hidden = false
        this.errorTarget.textContent = "Login succeeded but no Bearer token was returned."
      }
      return
    }

    sessionStorage.setItem(TOKEN_KEY, data.token)
    Turbo.visit(data.redirect_url || "/profile")
  }
}
