// Choose the route your API exposes, e.g. POST /submit
const API_PATH = "/submit";

const form = document.getElementById("inputForm");
const inputEl = document.getElementById("userInput");
const responseBox = document.getElementById("responseBox");
const statusEl = document.getElementById("status");
const submitBtn = document.getElementById("submitBtn");

function setStatus(text, mode) {
  statusEl.textContent = text;
  statusEl.classList.remove("ok", "err");
  if (mode) statusEl.classList.add(mode);
}

function prettyPrint(obj) {
  return JSON.stringify(obj, null, 2);
}

async function safeReadResponse(res) {
  const contentType = res.headers.get("content-type") || "";
  const bodyText = await res.text();

  if (contentType.includes("application/json")) {
    try {
      return { parsed: JSON.parse(bodyText), raw: bodyText };
    } catch {
      return { parsed: null, raw: bodyText };
    }
  }

  // Not JSON
  try {
    // Sometimes APIs return JSON without content-type set correctly
    return { parsed: JSON.parse(bodyText), raw: bodyText };
  } catch {
    return { parsed: null, raw: bodyText };
  }
}

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const userInput = inputEl.value.trim();
  if (!userInput) return;

  // UI state
  submitBtn.disabled = true;
  setStatus("Sending...", null);
  responseBox.textContent = "{}";

  const url = `${API_PATH}`;

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      // If you use IAM/Cognito auth later, you may need credentials or tokens.
      body: JSON.stringify({ input: userInput })
    });

    const { parsed, raw } = await safeReadResponse(res);

    if (!res.ok) {
      setStatus(`Error (${res.status})`, "err");
      responseBox.textContent = parsed ? prettyPrint(parsed) : raw || "(no body)";
      return;
    }

    setStatus(`OK (${res.status})`, "ok");
    responseBox.textContent = parsed ? prettyPrint(parsed) : raw || "(no body)";
  } catch (err) {
    setStatus("Network error", "err");
    responseBox.textContent = prettyPrint({
      message: "Request failed",
      error: String(err)
    });
  } finally {
    submitBtn.disabled = false;
  }
})
