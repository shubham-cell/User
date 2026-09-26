import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "empty", "count", "search", "pill", "bar", "meter"]
  static values = { active: { type: String, default: "all" } }

  connect() {
    this.apply()
    this.animateMeter()
  }

  select(event) {
    this.activeValue = event.currentTarget.dataset.filter
    this.pillTargets.forEach((button) => {
      button.classList.toggle("is-active", button.dataset.filter === this.activeValue)
    })
    this.apply()
  }

  search() {
    this.apply()
  }

  apply() {
    const query = (this.hasSearchTarget ? this.searchTarget.value : "").trim().toLowerCase()
    let visible = 0

    this.rowTargets.forEach((row) => {
      const type = row.dataset.type
      const text = row.dataset.search || ""
      const matchesFilter = this.activeValue === "all" || type === this.activeValue
      const matchesSearch = query === "" || text.includes(query)
      const show = matchesFilter && matchesSearch
      row.classList.toggle("is-hidden", !show)
      if (show) visible += 1
    })

    if (this.hasEmptyTarget) {
      this.emptyTarget.classList.toggle("is-hidden", visible > 0)
    }
    if (this.hasCountTarget) this.countTarget.textContent = visible
  }

  animateMeter() {
    if (!this.hasBarTarget || !this.hasMeterTarget) return

    const percent = Number(this.meterTarget.dataset.percent || 0)
    requestAnimationFrame(() => {
      this.barTarget.style.width = `${Math.min(Math.max(percent, 0), 100)}%`
    })
  }
}
