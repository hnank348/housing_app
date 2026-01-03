var BASE_URL = "http://127.0.0.1:8000";
var ADMIN_TOKEN = localStorage.getItem("admin_token");

function fetchPendingUsers() {
  var container = document.getElementById("pending");
  container.innerHTML = "جاري التحميل...";

  var xhr = new XMLHttpRequest();
  xhr.open("GET", BASE_URL + "/api/admin/pending");
  xhr.setRequestHeader("Authorization", "Bearer " + ADMIN_TOKEN);
  xhr.setRequestHeader("Accept", "application/json");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      container.innerHTML = "";

      if (xhr.status === 200) {
        var res = JSON.parse(xhr.responseText);

        // التعديل هنا: السيرفر يرسل البيانات داخل res.users بناءً على الكود الناجح لديك
        var users = res.users ? res.users : (res.data ? res.data : res);

        if (!users || users.length === 0) {
          container.innerHTML = "لا يوجد طلبات معلقة";
          return;
        }

        for (var i = 0; i < users.length; i++) {
          var u = users[i];

          container.innerHTML +=
            "<div style='border:1px solid #ccc;padding:10px;margin:10px'>" +
            "<p><b>الاسم:</b> " + u.first_name + " " + u.last_name + "</p>" +
            "<p><b>الهاتف:</b> " + u.phone + "</p>" +
            "<p><b>الجنس:</b> " + u.gender + "</p>" +
            "<p><b>تاريخ الميلاد:</b> " + u.birth_date + "</p>" +
            "<p><b>صورة الهوية:</b><br><img src='" + u.id_image + "' width='120'></p>" +
            "<p><b>الصورة الشخصية:</b><br><img src='" + u.profile_image + "' width='120'></p>" +
            "<button onclick=\"approveUser(" + u.id + ")\">موافقة</button> " +
            "<button onclick=\"rejectUser(" + u.id + ")\">رفض</button>" +
            "</div>";
        }
      } else {
        container.innerHTML = "خطأ في جلب البيانات: " + xhr.status;
      }
    }
  };

  xhr.send();
}

function approveUser(id) {
  var xhr = new XMLHttpRequest();
  xhr.open("POST", BASE_URL + "/api/admin/approve/" + id, true);
  xhr.setRequestHeader("Authorization", "Bearer " + ADMIN_TOKEN);

  xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200) {
          alert("تمت الموافقة");
          fetchPendingUsers();
      }
  };
  xhr.send();
}

function rejectUser(id) {
  var reason = prompt("سبب الرفض:");
  if (!reason) return;

  var xhr = new XMLHttpRequest();
  xhr.open("POST", BASE_URL + "/api/admin/reject/" + id, true);
  xhr.setRequestHeader("Authorization", "Bearer " + ADMIN_TOKEN);
  xhr.setRequestHeader("Content-Type", "application/json");

  xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200) {
          alert("تم الرفض");
          fetchPendingUsers();
      }
  };
  xhr.send(JSON.stringify({ reason: reason }));
}

fetchPendingUsers();