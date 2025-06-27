'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "6f6d188e80a24735ed3c56be4b736ee8",
".git/config": "ce9b48646b7f63c19c08a333f52a3d08",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "5c40c76c561faff0569c9901ade8e4c3",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "9880247029674bb7ca62d66d742a02f5",
".git/logs/refs/heads/gh-pages": "2482d72e0c43979569c36b334a4cb7b9",
".git/logs/refs/heads/master": "8f5ffec99e72ef06840ab02b6ae21307",
".git/logs/refs/remotes/origin/gh-pages": "97e9d48a3d91a7cc05bbbb7628e998fa",
".git/objects/01/974bce4bb218f356fb041efdd1f7928a02ca32": "433eefcbf0a83f96bd3338f512192962",
".git/objects/03/eaddffb9c0e55fb7b5f9b378d9134d8d75dd37": "87850ce0a3dd72f458581004b58ac0d6",
".git/objects/08/81db50ec674591c301a31ec48c657897760d3c": "9a430375469e79d386ac964b4e95450b",
".git/objects/24/ee4bb53b3f7095302dee92dc3573fb5525d9f7": "5ff21e9272b7b187dbbb9ee0d198a1dc",
".git/objects/34/27be90c6eeb9df43357df25fd399639f75a51e": "6e5d1e65bade61e78dd9c3e479671eb1",
".git/objects/3a/bfc6d2f6a7e3c5e01065527f7ec0e9961f00a8": "c9375548423c8eabd1d34a46e26b9d39",
".git/objects/3c/4d3fa96b75fb732557c00357e162d5710d17ea": "d0510c8bb7507b907632a681a9f345b6",
".git/objects/41/e4be06a842a310d266b733232f116428b19c03": "d8ab07f483e5a1f181f3f9688a455c89",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/48/84ca0c1cdea8fe4141846d0fc2a10e3ef8764b": "42168c64fb24cbaf4cb289fde9141880",
".git/objects/51/c58dcceb587c9e5b1bc46bbffb965413fdf3ce": "acc1bf028d38e32a1b2b61bdfcbb334a",
".git/objects/54/8d1f5db71a877e28abd67b880d048d77bf90f2": "16df6c972ef5f227ba1eb3832094dedc",
".git/objects/56/cbc295979e6a4beba4b27c5fd4ac026a80b28e": "59bd189b8e98eed5c9020f49a969039a",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/57/ce815fae6aa6822e61b4ada5e7413f4ea0ec9e": "7c5be8215fb10f795c389e4fbfdb866b",
".git/objects/5d/4b469eb04e47bfc7f52664c6a80eec69df250b": "ca0f374300bf3b39463497f69313c1a7",
".git/objects/69/dd618354fa4dade8a26e0fd18f5e87dd079236": "8cc17911af57a5f6dc0b9ee255bb1a93",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6c/1e4a6af9e840862a54d0270ff6383e8814765a": "548705e1f433d3c6c6a7412ed90f0dc1",
".git/objects/6c/8588d4edceb5aec20a5706af17cb882b7d6285": "727f5e15d463fad6e563dd367ef5d7f9",
".git/objects/7d/dbe573622de44a85451bae763f56ed97393af2": "99787ac3d5875f23db05e548f8868cb4",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/e7af5a3e840b75b70e59c3ffda1b58e84a5a1c": "e3695ae5742d7e56a9c696f82745288d",
".git/objects/90/981418e2de29f0c71659cb6e20162376a52166": "12527fdc84dc966d4f1c880befa5c2d4",
".git/objects/a0/87e23cf00ffe0380c176e27d9b78541e197514": "2bae57df90d7833b8455125ec87a0c25",
".git/objects/a3/e2b3c608c8010e75a763214af15bdfa680934a": "675490f9f0d69affb9a47fa97349e250",
".git/objects/a5/8624bbb86657c4791502d8c739f09e9599707e": "eca303eacb50bfb29c033489b0508ab2",
".git/objects/a6/c84983b8aaf8969777d8cd1945f1b1f4a39a1d": "1c495574e4bf286649eca0f7615a94e4",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/ad/dee6b55166988e5c8175f0d1c82544fb99d19d": "4688597642a09fa1cb61e903fdcfae45",
".git/objects/ad/ec5c5f0c71e8d8b6f7c719c0776cee0d432147": "ccfc6f458e418d040178a0fd75f496d2",
".git/objects/b3/a75d18c8d81f43782fb2b24144d2f8d9a32210": "9621816b698af3b0fea46265f73fe02d",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/4eaed7b664ffd58bc6b2311976d7c9486347a8": "8b7aedbb246ebb38e389a588420616fd",
".git/objects/bd/14527a414d737d97ed8ab62f58b433af851386": "2618684c8f27f93fe7087615cb613aaa",
".git/objects/c3/8f9050b603f4b90abc4f7b629198aadd14747d": "3d9ea71fc122e12c3f6ec6842bca0399",
".git/objects/cd/bc866275d2a467bd8fd9035ac8717a0f475c46": "da9b910e416a604bfddd864bc828669d",
".git/objects/ce/2560ede1400efc5eb3c2b4c20a772bfdf15959": "cfe2c5d0547b7dde2559185fd814e3c7",
".git/objects/d1/5519824d70ceeb8c21f007d3adff92b75b39e5": "e2b7430add927a626983725575e37d6b",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/df/b3769e14d71a22e708135105816021f11cdda0": "6ca7eee64c903eff72575fcb8ed0541f",
".git/objects/e6/ab18b59159b5a1137acc96344074938042aaf3": "84208ebd16709f14eb3dc707605a7db0",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ee/9bdd911bd0949b5781aa178d38379344f271d1": "44f0cd6653713cdb91ff1ca82e27bf7e",
".git/objects/f1/c08e96c11d574a48333482fd74b56bbef91b17": "08345a77048d0b2eaae67116a214ccaf",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/fd/010beac182efc59bd051982046ce2b60113c59": "aa80831e11c1685bb1389b01f6689204",
".git/objects/fe/b2b7617f32e89bb13c1513f6f8d477296ff71d": "e0d76eb7d94aa217176505f32832abe7",
".git/objects/ff/fb46b5a196860816f524a8b714b3be196e98eb": "79404fc5ffc45de83361df502c0faafb",
".git/refs/heads/gh-pages": "ae6725dd59570b2877ffb3eff056efb9",
".git/refs/heads/master": "8348a83455270e4d9a1a030d3c11744d",
".git/refs/remotes/origin/gh-pages": "ae6725dd59570b2877ffb3eff056efb9",
"assets/AssetManifest.bin": "693635b5258fe5f1cda720cf224f158c",
"assets/AssetManifest.bin.json": "69a99f98c8b1fb8111c5fb961769fcd8",
"assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "24f71282f8a6c9b91e78bf9e461aa799",
"assets/NOTICES": "b37895bce4ee232b1c2374e0476185c2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "8cf6e87eff144e2453a9640bfa1a4ad0",
"canvaskit/canvaskit.js.symbols": "175bd411bd217d6be2b81e6814ba040e",
"canvaskit/canvaskit.wasm": "9c1d5989342561acfecba39e516f1d73",
"canvaskit/chromium/canvaskit.js": "9dc7a140b1f0755e6321e9c61b9bd4d9",
"canvaskit/chromium/canvaskit.js.symbols": "226d130dfe086da9114583db7ab8dca5",
"canvaskit/chromium/canvaskit.wasm": "109a9f1f6d0fcc6b8b17b3cc9cc06b4b",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "d3b3cc22385d4ac873dd2157360155e0",
"canvaskit/skwasm.wasm": "bba3d030323fb4f2e2262a0e90390dd1",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "66594078c390ce22386607adb437f8eb",
"canvaskit/skwasm_st.wasm": "eba51262a05b87a26d420a55481799d3",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "b121d2f89b647a9621e6cf643922433f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ecb7f54478f5e47271ff10860682d3f9",
"/": "ecb7f54478f5e47271ff10860682d3f9",
"main.dart.js": "a262ca29e7e12c5be9f0953e871c9f8e",
"manifest.json": "1bf23f23e06ada64c270c4580e146778",
"version.json": "02c350513aaee5ca399629f844b44d8a"};
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
