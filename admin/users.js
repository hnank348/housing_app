var BASE_URL = "http://127.0.0.1:8000";
var ADMIN_TOKEN = localStorage.getItem("admin_token");

// دالة جلب وعرض كل المستخدمين
function fetchAllUsers() {
  var container = document.getElementById("users");
  if (!container) return;
  container.innerHTML = "جاري التحميل...";

  var xhr = new XMLHttpRequest();
  xhr.open("GET", BASE_URL + "/api/admin/index", true);
  xhr.setRequestHeader("Authorization", "Bearer " + ADMIN_TOKEN);
  xhr.setRequestHeader("Accept", "application/json");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      container.innerHTML = "";

      if (xhr.status === 200) {
        var res = JSON.parse(xhr.responseText);

        var users = res.users;

        if (!users || users.length === 0) {
          container.innerHTML = "لا يوجد مستخدمين حالياً";
          return;
        }

        for (var i = 0; i < users.length; i++) {
          var u = users[i];

          container.innerHTML +=
            "<div style='border:1px solid #ccc;padding:10px;margin:10px;border-radius:8px'>" +
            "<p><b>الاسم:</b> " + u.first_name + " " + u.last_name + "</p>" +
            "<p><b>الهاتف:</b> " + u.phone + "</p>" +
            "<p><b>الجنس:</b> " + u.gender + "</p>" +
            "<p><b>تاريخ الميلاد:</b> " + u.birth_date + "</p>" +
            "<p><b>صورة الهوية:</b><br><img src='" + u.id_image + "' width='120'></p>" +
            "<p><b>الصورة الشخصية:</b><br><img src='" + u.profile_image + "' width='120'></p>" +
            "<button onclick=\"rejectUser(" + u.id + ")\" style='background-color:red;color:white;border:none;padding:5px 10px;cursor:pointer;'>حذف</button>" +
            "</div>";
        }
      } else if (xhr.status === 403) {
        container.innerHTML = "❌ لا تملك صلاحية الأدمن (403)";
      } else {
        container.innerHTML = "خطأ في جلب البيانات: " + xhr.status;
      }
    }
  };

  xhr.send();
}

function rejectUser(id) {
  var reason = prompt("سبب الحذف:");
  if (!reason) return;

  var xhr = new XMLHttpRequest();
  xhr.open("DELETE", BASE_URL + "/api/admin/delete/" + id, true);
  xhr.setRequestHeader("Authorization", "Bearer " + ADMIN_TOKEN);
  xhr.setRequestHeader("Content-Type", "application/json");
  xhr.setRequestHeader("Accept", "application/json");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (xhr.status === 200 || xhr.status === 201) {
        alert("تم الحذف بنجاح");
        fetchAllUsers();
      } else {
        var errorInfo = "فشل الحذف: " + xhr.status;
        try {
           var errorRes = JSON.parse(xhr.responseText);
           if(errorRes.message) errorInfo += "\n" + errorRes.message;
        } catch(e) {}
        alert(errorInfo);
      }
    }
  };

  xhr.send(JSON.stringify({ reason: reason }));
}

fetchAllUsers();