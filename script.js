const header = document.querySelector(".site-header");
const menuButton = document.querySelector(".menu-toggle");
const year = document.querySelector("#year");
const chatWidget = document.querySelector(".chat-widget");
const chatToggle = document.querySelector(".chat-toggle");
const chatPanel = document.querySelector("#chat-panel");
const chatClose = document.querySelector(".chat-close");
const chatForm = document.querySelector(".chat-form");
const chatName = document.querySelector("#chat-name");
const chatMessage = document.querySelector("#chat-message");
const businessPhone = "18643953094";

if (year) {
  year.textContent = new Date().getFullYear();
}

if (header && menuButton) {
  menuButton.addEventListener("click", () => {
    const isOpen = header.classList.toggle("nav-open");
    menuButton.setAttribute("aria-expanded", String(isOpen));
  });

  header.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      header.classList.remove("nav-open");
      menuButton.setAttribute("aria-expanded", "false");
    });
  });
}

if (chatWidget && chatToggle && chatPanel) {
  const setChatOpen = (isOpen) => {
    chatWidget.classList.toggle("chat-open", isOpen);
    chatToggle.setAttribute("aria-expanded", String(isOpen));
    chatPanel.hidden = !isOpen;

    if (isOpen && chatMessage) {
      chatMessage.focus();
    }
  };

  chatToggle.addEventListener("click", () => {
    setChatOpen(chatPanel.hidden);
  });

  chatClose?.addEventListener("click", () => {
    setChatOpen(false);
    chatToggle.focus();
  });

  chatForm?.addEventListener("submit", (event) => {
    event.preventDefault();

    if (!chatMessage?.value.trim()) {
      chatMessage?.focus();
      return;
    }

    const name = chatName?.value.trim();
    const message = chatMessage.value.trim();
    const text = name
      ? `Hi, this is ${name}. ${message}`
      : `Hi, I am interested in Neat & Bright Homes. ${message}`;

    window.location.href = `sms:+${businessPhone}?body=${encodeURIComponent(text)}`;
  });
}
