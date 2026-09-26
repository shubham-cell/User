// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"

const TOKEN_KEY = "auth_token"

function bearerToken() {
  return sessionStorage.getItem(TOKEN_KEY)
}

function clearBearerToken() {
  sessionStorage.removeItem(TOKEN_KEY)
}

// Attach Authorization: Bearer <token> on every Turbo request.
document.addEventListener("turbo:before-fetch-request", (event) => {
  const token = bearerToken()
  if (!token) return

  const headers = event.detail.fetchOptions.headers
  if (headers instanceof Headers) {
    headers.set("Authorization", `Bearer ${token}`)
  } else {
    headers["Authorization"] = `Bearer ${token}`
  }
})

// After hard refresh: re-visit via Turbo so the Bearer header is sent.
document.addEventListener("DOMContentLoaded", () => {
  const token = bearerToken()
  const authenticated = document.body?.dataset?.authenticated === "true"
  if (!token || authenticated) return
  if (window.location.pathname === "/login") return

  Turbo.visit(window.location.href, { action: "replace" })
})

// Clear local Bearer token when logout finishes (lands on login).
document.addEventListener("turbo:load", () => {
  if (window.location.pathname === "/login" && document.body?.dataset?.authenticated !== "true") {
    // Keep token if user opened login while still having a valid token elsewhere;
    // only clear when logout link/idle explicitly cleared, handled below.
  }
})

document.addEventListener("click", (event) => {
  const link = event.target.closest("a[href='/logout'], a[href*='logout']")
  if (!link) return

  // Let the logout request go out with Bearer first, then drop the local token.
  document.addEventListener("turbo:load", clearBearerToken, { once: true })
})
