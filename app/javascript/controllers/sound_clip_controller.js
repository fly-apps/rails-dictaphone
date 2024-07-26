import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sound-clip"
export default class extends Controller {
  static targets = ["name"]
  connect() {
    this.nameTarget.addEventListener("click", () => {
      const newClipName = prompt("Enter a new name for your sound clip?");
      if (newClipName) {
        const form = this.element.querySelector("form");
        const input = form.querySelector("input[type='text']");
        input.value = newClipName;
        form.submit();
      }
    })
  }
}
