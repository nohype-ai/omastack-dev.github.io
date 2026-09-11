function copySetup(btn) {
  const code = document.getElementById("setup").textContent;
  navigator.clipboard.writeText(code).then(function () {
    const original = btn.textContent;
    btn.textContent = "Copied";
    btn.classList.add("copied");
    setTimeout(function () {
      btn.textContent = original;
      btn.classList.remove("copied");
    }, 1800);
  });
}

document.addEventListener("DOMContentLoaded", function () {
  const btn = document.querySelector(".terminal button");
  if (btn) {
    btn.addEventListener("click", function () {
      copySetup(btn);
    });
  }
});
