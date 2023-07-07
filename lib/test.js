


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
