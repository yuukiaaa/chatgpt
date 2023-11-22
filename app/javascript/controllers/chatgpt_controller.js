import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "outputSocrates", "outputPlato", "outputAristotle"];
  
  askChatgpt(event) {
    event.preventDefault();

    let input = {"message": this.inputTarget.value};
    let xhr = new XMLHttpRequest();

    xhr.open("POST", "/tops/message");

    let token = document.querySelector("[name='csrf-token']").content;
    xhr.setRequestHeader("X-CSRF-Token", token);

    xhr.setRequestHeader("Content-Type", "application/json");
    console.log(xhr);
    console.log(input);
    xhr.send(JSON.stringify(input));

    xhr.onload = () => {
      if (xhr.status === 200) {
        let res = JSON.parse(xhr.responseText);
        this.outputSocratesTarget.innerHTML = res["ソクラテス"];
        this.outputPlatoTarget.innerHTML = res["プラトン"];
        this.outputAristotleTarget.innerHTML = res["アリストテレス"];
        console.log("成功")
      } else {
        this.outputSocratesTarget.innerHTML = "エラーが発生しました。"
        console.log(xhr.status);
        console.log(xhr.statusText);
        console.log(xhr.responseText);
      }
    }
    xhr.onerror = function() {
      // エラー内容をコンソールに出力
      console.error("通信に失敗しました");
      console.error("readyState: " + xhr.readyState);
      console.error("status: " + xhr.status);
      console.error("statusText: " + xhr.statusText);
    };

    // this.outputSocratesTarget.innerHTML = "socrates";
    // this.outputPlatoTarget.innerHTML ="plato";
    // this.outputAristotleTarget.innerHTML = "aristotle";

  }


}