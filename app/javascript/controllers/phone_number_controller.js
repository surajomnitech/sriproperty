import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {}

  add(event) {
    const template = document.getElementById('phone-number-template')
    if (template) {
      const timestamp = new Date().getTime()
      const newField = template.innerHTML.replace(/NEW_RECORD/g, timestamp)
      const container = this.element.querySelector('.phone-numbers-container')
      if (container) {
        container.insertAdjacentHTML('beforeend', newField)
      }
    }
  }

  remove(event) {
    const fieldSet = event.currentTarget.closest('.input-group')
    const destroyFlag = fieldSet.querySelector('.destroy-flag')
    if (destroyFlag) {
      destroyFlag.checked = true
      fieldSet.style.display = 'none'
    }
  }

  removeNew(event) {
    const fieldSet = event.currentTarget.closest('.input-group')
    fieldSet.remove()
  }
}