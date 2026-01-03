
var BASE_URL = "http://127.0.0.1:8000";

function adminLogin() {
  var phone = document.getElementById("phone").value;
  var password = document.getElementById("password").value;

  var formData = new FormData();
  formData.append("phone", phone);
  formData.append("password", password);

  fetch(BASE_URL + "/api/login", {
    method: "POST",
    body: formData,
    headers: {
      "Accept": "application/json"
    }
  })
  .then(res => res.json())
  .then(data => {
    if (!data.token) {
      document.getElementById("error").innerText = "بيانات خاطئة";
      return;
    }

    localStorage.setItem("admin_token", data.token);
    window.location.href = "admin_home.html";
  })
  .catch(err => {
    console.error(err);
    document.getElementById("error").innerText = "حدث خطأ في الاتصال";
  });
}