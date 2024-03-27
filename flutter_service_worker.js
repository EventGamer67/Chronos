'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"splash/img/light-4x.png": "8b41f19e7e83c8c9498020e951a94617",
"splash/img/dark-2x.png": "b8b95087a5aad001ce985a2cc5044416",
"splash/img/light-3x.png": "89f8451e4ece8402e1b2ee36ae4cf310",
"splash/img/light-2x.png": "b8b95087a5aad001ce985a2cc5044416",
"splash/img/dark-4x.png": "8b41f19e7e83c8c9498020e951a94617",
"splash/img/dark-1x.png": "713ac6188d3caaf61c2c196c4bbdb42c",
"splash/img/dark-3x.png": "89f8451e4ece8402e1b2ee36ae4cf310",
"splash/img/light-1x.png": "713ac6188d3caaf61c2c196c4bbdb42c",
"index.html": "55003e514588907e229c03ba73bc09ce",
"/": "55003e514588907e229c03ba73bc09ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"metrica.js": "d41d8cd98f00b204e9800998ecf8427e",
"favicon.png": "72e239ad8cbe8741641afe451d858243",
"assets/FontManifest.json": "617a7f013847df101c5f6a7041521272",
"assets/fonts/MaterialIcons-Regular.otf": "8d5876306f53363e7eaf5a75d6550a60",
"assets/AssetManifest.bin.json": "596277536fb27389848a788df172b062",
"assets/assets/fonts/SpaceMono-Regular.ttf": "96985f7a507afce5ab786569d2b2368f",
"assets/assets/fonts/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/assets/icon/vuesax_linear_award.svg": "45aa348844b4a0a78576d1f622e99bd3",
"assets/assets/icon/link-2.svg": "56754c9f5cb0a99f18d42dd27a7db8ba",
"assets/assets/icon/vuesax_linear_location.svg": "4e8fa40629c0aad9a37ca060dd0ab57c",
"assets/assets/icon/notification.svg": "3141973ce61973e61dbe44b175883edc",
"assets/assets/icon/vuesax_linear_send-2.svg": "cd597078aa0818985bb41ac0d4e242f4",
"assets/assets/icon/vuesax_linear_setting-2.svg": "196156a186248fe478d2647942153c70",
"assets/assets/icon/vuesax_linear_note.svg": "5720c86fcddba7572e5065968cb2ff75",
"assets/assets/icon/vuesax_linear_message-programming.svg": "395623010fb927b9c3622f20cac355da",
"assets/assets/icon/vuesax_linear_teacher.svg": "4e37cf86cdd7400885f3ffab99659074",
"assets/assets/icon/whale.png": "5079c30fba79d8021b5c0c2e4ea8a2c7",
"assets/assets/icon/whale_android.png": "5f9eeda340eb6d2405e7e6ae244aa432",
"assets/assets/icon/vuesax_linear_moon.svg": "f7f0b4db979b37e6ed4f11202a4f823b",
"assets/assets/icon/vuesax_linear_sun-2.svg": "810d4603b63c52f1e101952656f99ec4",
"assets/AssetManifest.bin": "a85b340eb7e7f67fd9e22e64cc6b8030",
"assets/NOTICES": "5d5cbafd33793ff2dd4cc79c3cba365d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/mobkit_dashed_border/images/type2.png": "17a23dec244c3d1bb5b4ae67d7bd48b3",
"assets/packages/mobkit_dashed_border/images/type3.png": "2d50ab9d78a15b2f20012c3b9ea56c46",
"assets/packages/mobkit_dashed_border/images/type4.png": "9250b4ccf17768b5c7d6afcaebadf3f9",
"assets/packages/mobkit_dashed_border/images/type1.png": "9f8e612a54622229bd4b97e5357a473c",
"assets/AssetManifest.json": "1c3b78dc83f73c21d0078df45ce79697",
"version.json": "0a0d4ac3e421f56d4aced7443549f199",
"icons/Icon-512.png": "c9e2526a8af70a64289aaef2908cc16b",
"icons/Icon-maskable-192.png": "51b125f9abc70be7290fee2db0ef86f0",
"icons/Icon-maskable-512.png": "ab33e597301b3ef44bd81b4617f743c7",
"icons/Icon-192.png": "c2c67fdc75ef907449be106027d0448d",
"manifest.json": "9a03448635b0aaa3b7790e061297b891",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"main.dart.js": "26dec36570fea415bf5c00cc0eda878c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
