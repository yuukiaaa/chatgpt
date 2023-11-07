// $(function(){
//   console.log('confirmation test');
//   alert("confirmation test");
// });

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["in", "test1"];

  hello(event) {
    event.preventDefault();
    let input = this.inTarget.value;
    this.test1Target.textContent = input
  }
}
