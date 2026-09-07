import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "suggestions", "selectedList", "hiddenField", "chip"];
  static values = { 
    allTags: Array,
    maxCount: { type: Number, default: 10 },
    maxLength: { type: Number, default: 10 },
  };

  connect() {
    this.selected = new Set(
      this.chipTargets.map((el) => el.dataset.tagName)
    );
    this.syncHiddenField();
  }

  search() {
    const keyword = this.inputTarget.value.trim();
    this.suggestionsTarget.innerHTML = "";
    if (!keyword) return;

    const matches = this.allTagsValue.filter(
      (name) => name.includes(keyword) && !this.selected.has(name)
    );

    matches.slice(0, 5).forEach((name) => {
      const li = document.createElement("li");
      li.className = "list-group-item list-group-item-action";
      li.style.cursor = "pointer";
      li.textContent = name;
      li.addEventListener("click", () => this.select(name));
      this.suggestionsTarget.appendChild(li);
    });
  }

  addFromInput(event) {
    event.preventDefault();
    const name = this.inputTarget.value.trim();
    if (!name) return;
    this.select(name);
  }

  select(name) {
    if (this.selected.has(name)) return;

    if (this.selected.size >= this.maxCountValue) {
      alert(`タグは${this.maxCountValue}個までです`);
      return;
    }

    if (name.length > this.maxLengthValue) {
      alert(`タグは${this.maxLengthValue}文字以内で入力してください`);
      return;
    }

    this.selected.add(name);
    this.renderChip(name);
    this.inputTarget.value = "";
    this.suggestionsTarget.innerHTML = "";
    this.syncHiddenField();
  }

  remove(event) {
    const chip = event.target.closest("[data-tag-name]");
    const name = chip.dataset.tagName;
    this.selected.delete(name);
    chip.remove();
    this.syncHiddenField();
  }

  renderChip(name) {
    const chip = document.createElement("span");
    chip.className = "badge rounded-pill badge-feature me-1";
    chip.dataset.tagPickerTarget = "chip";
    chip.dataset.tagName = name;
    chip.innerHTML = `${name} <span class="ms-1" data-action="click->tag-picker#remove" style="cursor:pointer;">×</span>`;
    this.selectedListTarget.appendChild(chip);
  }

  syncHiddenField() {
    this.hiddenFieldTarget.value = Array.from(this.selected).join(",");
  }
}