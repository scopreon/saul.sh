// Create WebSocket connection.
const socket = new WebSocket("ws://localhost:8765");

// Connection opened
socket.addEventListener("open", (event) => {
  socket.send("Hello Server!");
});

// Listen for messages
socket.addEventListener("message", (event) => {
document.getElementById("demo").textContent = event.data;
  console.log("Message from server ", event.data);
});
