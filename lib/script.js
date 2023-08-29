function getPlatform() {
  return window.navigator.userAgent;
}

function createAlert() {
  console.log("Hello World");
  // window.alert("Hello World");
  // navigator.alert("Hello World");
}

async function jsPromiseFunction(message) {
  let msg = message;
  let promise = new Promise(function (resolve, reject) {
    resolve("Hello : " + message);
  });
  let result = await promise;
  return result;
}

async function jsOpenTabFunction(url) {
  let promise = new Promise(function (resolve, reject) {
    var win = window.open(url, "New Popup Window", "width=800,height=800");
    console.log("window", win);

    var timer = setInterval(function () {
      if (win.closed) {
        clearInterval(timer);
        alert("'Popup Window' closed!");
        resolve("Paid");
      }
    }, 500);
    console.log("window", win);
  });
  let result = await promise;
  console.log("result", result);
  return result;
}

async function test() {
  if ("xr" in navigator) {
    // Initialisieren des Polyfills
    //   const polyfill = new WebXRPolyfill();
    // Erstellen einer neuen XRSession
    try {
      // this.xrSession = await navigator.xr.requestSession("immersive-vr");
      navigator.x;
      // Setup der VR/AR-Szene nach dem Erstellen der Session
      this.setupXRScene();
    } catch (err) {
      console.error("Unable to create an XR session:", err);
    }
  } else {
    console.error("WebXR not supported by this browser");
  }
}

async function checkJS() {
  console.log("checkJS");
  if ("xr" in navigator) {
    console.log("yes");
  } else {
    console.log("no");
  }
}
