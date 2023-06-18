// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getMessaging, getToken } from "firebase/messaging";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID",
  measurementId: "YOUR_MEASUREMENT_ID" // Firebase JS SDK v7.20.0以降ではオプションです
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

// Get the messaging instance
const messaging = getMessaging(app);

// Request permission and get the token
getToken(messaging, { vapidKey: "YOUR_VAPID_KEY" })
  .then((currentToken) => {
    if (currentToken) {
      console.log("FCM Token:", currentToken);
      // トークンの取得が成功した場合の処理を記述します
    } else {
      console.log("No registration token available.");
    }
  })
  .catch((error) => {
    console.log("An error occurred while retrieving token.", error);
  });
