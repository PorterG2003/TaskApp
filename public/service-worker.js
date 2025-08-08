const CACHE_VERSION = 'v1';
const CACHE_NAME = `taskapp-${CACHE_VERSION}`;

// Assets to cache
const PRECACHE_ASSETS = [
  '/',
  '/offline',
  '/mountains_bg.jpg',
  '/appimages/android/android-launchericon-192-192.png',
  '/appimages/android/android-launchericon-512-512.png',
  '/appimages/ios/180.png',
  '/appimages/ios/1024.png',
  '/appimages/windows11/Square150x150Logo.scale-200.png'
];

// Install event
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(PRECACHE_ASSETS))
      .then(() => self.skipWaiting())
  );
});

// Activate event
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(cacheName => cacheName.startsWith('taskapp-') && cacheName !== CACHE_NAME)
          .map(cacheName => caches.delete(cacheName))
      );
    })
  );
});

// Fetch event
self.addEventListener('fetch', event => {
  // Skip non-GET requests
  if (event.request.method !== 'GET') return;

  // Skip chrome-extension requests
  if (event.request.url.startsWith('chrome-extension://')) return;

  // Handle API requests
  if (event.request.url.includes('/api/')) {
    return event.respondWith(
      fetch(event.request)
        .catch(() => {
          return new Response(
            JSON.stringify({ error: 'You are offline' }),
            { headers: { 'Content-Type': 'application/json' } }
          );
        })
    );
  }

  // Handle page navigation
  if (event.request.mode === 'navigate') {
    return event.respondWith(
      fetch(event.request)
        .catch(() => {
          return caches.match('/offline');
        })
    );
  }

  // Handle other requests with cache-first strategy
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }

        return fetch(event.request)
          .then(response => {
            // Cache successful responses
            if (response.ok && response.type === 'basic') {
              const responseToCache = response.clone();
              caches.open(CACHE_NAME)
                .then(cache => {
                  cache.put(event.request, responseToCache);
                });
            }
            return response;
          })
          .catch(() => {
            // Return offline page for HTML requests
            if (event.request.headers.get('Accept').includes('text/html')) {
              return caches.match('/offline');
            }
          });
      })
  );
});