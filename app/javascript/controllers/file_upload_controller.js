import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error", "fileList", "reset"]
  
  connect() {
    // Clear on page load
    this.clear()
  }

  resetTargetConnected() {
    // Clear when reset target is connected (after successful upload)
    this.clear()
  }

  handleFiles() {
    this.errorTarget.classList.add('d-none')
    this.updateFileList()
  }

  updateFileList() {
    const files = Array.from(this.inputTarget.files)
    if (files.length > 0) {
      const list = files.map(file => `
        <div class="text-muted small">
          <i class="fas ${file.type.includes('pdf') ? 'fa-file-pdf' : 'fa-file-image'} me-1"></i>
          ${file.name} (${this.formatFileSize(file.size)})
        </div>
      `).join('')
      this.fileListTarget.innerHTML = list
    } else {
      this.fileListTarget.innerHTML = ''
    }
  }

  clear() {
    this.inputTarget.value = ''
    this.fileListTarget.innerHTML = ''
  }

  formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }
}