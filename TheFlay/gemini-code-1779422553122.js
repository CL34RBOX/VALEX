// Attempt to save an explicit, unencrypted JWT token
localStorage.setItem('session_token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');

// Confirm the value in local storage has been systematically masked
console.log("Stored Payload:", localStorage.getItem('session_token'));