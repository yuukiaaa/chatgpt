import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "outputSocrates", "outputPlato", "outputAristotle"];
  
  askChatgpt(event) {
    event.preventDefault();

    // let input = {"message": this.inputTarget.value};
    // let xhr = new XMLHttpRequest();

    // xhr.open("POST", "/tops/message");

    // let token = document.querySelector("[name='csrf-token']").content
    // xhr.setRequestHeader("X-CSRF-Token", token)

    // xhr.setRequestHeader("Content-Type", "application/json");
    // xhr.send(JSON.stringify(input));

    // xhr.onload = () => {
    //   if (xhr.status === 200) {
    //     this.outputTarget.innerHTML = xhr.responseText
    //     this.testTarget.innerHTML = xhr.responseText
    //     console.log("成功")
    //   } else {
    //     this.outputTarget.innerHTML = "エラーが発生しました。"
    //     console.log(xhr.status);
    //     console.log(xhr.statusText);
    //     console.log(xhr.responseText);
    //   }
    // }
    // xhr.onerror = function() {
    //   // エラー内容をコンソールに出力
    //   console.error("通信に失敗しました");
    //   console.error("readyState: " + xhr.readyState);
    //   console.error("status: " + xhr.status);
    //   console.error("statusText: " + xhr.statusText);
    // };

    this.outputSocratesTarget.innerHTML = "socrates";
    this.outputPlatoTarget.innerHTML ="plato";
    this.outputAristotleTarget.innerHTML = "aristotle";

  }


}