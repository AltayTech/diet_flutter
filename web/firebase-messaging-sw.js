importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
       apiKey: "AIzaSyBnqcxB9tpxsOu9PNKTvd0OuXi7k7zx0NE",
       authDomain: "behandam-test.firebaseapp.com",
       projectId: "behandam-test",
       storageBucket: "behandam-test.appspot.com",
       messagingSenderId: "343455511841",
       appId: "1:343455511841:web:19fc501195f6b0c1567a60",
       measurementId: "G-7FGHS67SXD"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});