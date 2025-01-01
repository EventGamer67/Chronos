'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js": "45742db9c0cff11f8040a876c509b7e5",
"splash/img/light-3x.png": "16d6e10786f2823d0fce00808684ff60",
"splash/img/light-1x.png": "deaece8cd5d75868c332ad7fce0cd39b",
"splash/img/light-2x.png": "4424c0a491eb0d85e6278bb721706155",
"splash/img/dark-3x.png": "16d6e10786f2823d0fce00808684ff60",
"splash/img/dark-1x.png": "deaece8cd5d75868c332ad7fce0cd39b",
"splash/img/dark-4x.png": "bd3f04a558a7e865a8204ab7658aa0f8",
"splash/img/light-4x.png": "bd3f04a558a7e865a8204ab7658aa0f8",
"splash/img/dark-2x.png": "4424c0a491eb0d85e6278bb721706155",
"assets/FontManifest.json": "617a7f013847df101c5f6a7041521272",
"assets/AssetManifest.bin": "7afec7ebca3097d32ebcfde7a8568e4d",
"assets/fonts/MaterialIcons-Regular.otf": "96b1329e6f3653f377d8978aa58a0b71",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/o3d/assets/template.html": "24a1f29951029adea5122572451138fc",
"assets/packages/o3d/assets/model-viewer.min.js": "a9dc98f8bf360be897a0898a7395f905",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/mobkit_dashed_border/images/type4.png": "9250b4ccf17768b5c7d6afcaebadf3f9",
"assets/packages/mobkit_dashed_border/images/type3.png": "2d50ab9d78a15b2f20012c3b9ea56c46",
"assets/packages/mobkit_dashed_border/images/type2.png": "17a23dec244c3d1bb5b4ae67d7bd48b3",
"assets/packages/mobkit_dashed_border/images/type1.png": "9f8e612a54622229bd4b97e5357a473c",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/assets/fonts/SpaceMono-Regular.ttf": "96985f7a507afce5ab786569d2b2368f",
"assets/assets/fonts/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/assets/icon/vuesax_linear_send-2.svg": "cd597078aa0818985bb41ac0d4e242f4",
"assets/assets/icon/whale_1f40b.png": "2048258d17b05f7be9c786a957cf9f81",
"assets/assets/icon/telegram.svg": "752e31b1dd01fa6b738132953ee06bb8",
"assets/assets/icon/link-2.svg": "56754c9f5cb0a99f18d42dd27a7db8ba",
"assets/assets/icon/vuesax_linear_moon.svg": "f7f0b4db979b37e6ed4f11202a4f823b",
"assets/assets/icon/vuesax_linear_setting-2.svg": "196156a186248fe478d2647942153c70",
"assets/assets/icon/snowflake.png": "5cf1916a88b933ad6ad4ac7348bc6aa3",
"assets/assets/icon/whale.png": "96e193d0b7c5a888f45a1f0cc5c0b6a6",
"assets/assets/icon/zamena.svg": "2624a9af743136802477f75c1cc25a02",
"assets/assets/icon/autumnleave.png": "c6dcfe79e04aa863a7ee0bd03b5f1991",
"assets/assets/icon/vuesax_linear_sun-2.svg": "810d4603b63c52f1e101952656f99ec4",
"assets/assets/icon/vuesax_linear_location.svg": "4e8fa40629c0aad9a37ca060dd0ab57c",
"assets/assets/icon/vuesax_linear_note.svg": "5720c86fcddba7572e5065968cb2ff75",
"assets/assets/icon/vuesax_linear_award.svg": "45aa348844b4a0a78576d1f622e99bd3",
"assets/assets/icon/note.svg": "49e1918836fce1b40d2ef88f582854e6",
"assets/assets/icon/zamena_bold.svg": "50eb27cc10758187b797c6b7865f5a1a",
"assets/assets/icon/vuesax_linear_teacher.svg": "4e37cf86cdd7400885f3ffab99659074",
"assets/assets/icon/whale_android.png": "976d3868916fb2cea22751699d13dc1b",
"assets/assets/icon/vuesax_linear_message-programming.svg": "395623010fb927b9c3622f20cac355da",
"assets/assets/icon/notification.svg": "3141973ce61973e61dbe44b175883edc",
"assets/assets/icon/setting-2.svg": "3edc1de54172b6e727bec0c3cd023dca",
"assets/assets/icon/boldnotification.svg": "b4ba6c4139d898fbd5a42b95fed76b40",
"assets/NOTICES": "ac5ef6b5a24c363c6e9ad7bb3d467e1e",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "04c631c0eb96d85e7c91424e7624008b",
"assets/AssetManifest.bin.json": "af63a5213e91aa7478626aac970da67d",
"index.html": "437833fbad9c7a5cf24266c945477a40",
"/": "437833fbad9c7a5cf24266c945477a40",
"manifest.json": "809ff8b69f358921cf62c5578e75a924",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "2506c347f81408b5fd9683626646defd",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"favicon.png": "0edcf9b037910956712c5221731e7895",
"version.json": "a9b1a29096a2375d7254a2514433905d",
"flutter_bootstrap.js": "969746674cbfcd42b1b0b9b96e841de4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
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
