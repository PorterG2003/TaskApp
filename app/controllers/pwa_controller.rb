class PwaController < ApplicationController
  skip_before_action :authenticate_user!
  
  def manifest
    render json: manifest_json, content_type: 'application/json'
  end

  def service_worker
    render file: 'public/service-worker.js', content_type: 'application/javascript'
  end

  private

  def manifest_json
    {
      name: "TaskApp",
      short_name: "TaskApp",
      description: "Manage tasks with Google Calendar integration",
      display: "standalone",
      scope: "/",
      start_url: "/",
      background_color: "#ffffff",
      theme_color: "#3b82f6",
      orientation: "portrait",
      icons: [
        # Android icons
        {
          src: "/appimages/android/android-launchericon-512-512.png",
          sizes: "512x512",
          type: "image/png",
          purpose: "any"
        },
        {
          src: "/appimages/android/android-launchericon-192-192.png",
          sizes: "192x192",
          type: "image/png",
          purpose: "any"
        },
        {
          src: "/appimages/android/android-launchericon-144-144.png",
          sizes: "144x144",
          type: "image/png"
        },
        {
          src: "/appimages/android/android-launchericon-96-96.png",
          sizes: "96x96",
          type: "image/png"
        },
        {
          src: "/appimages/android/android-launchericon-72-72.png",
          sizes: "72x72",
          type: "image/png"
        },
        {
          src: "/appimages/android/android-launchericon-48-48.png",
          sizes: "48x48",
          type: "image/png"
        },
        # iOS icons
        {
          src: "/appimages/ios/1024.png",
          sizes: "1024x1024",
          type: "image/png",
          purpose: "maskable"
        },
        {
          src: "/appimages/ios/180.png",
          sizes: "180x180",
          type: "image/png"
        },
        {
          src: "/appimages/ios/167.png",
          sizes: "167x167",
          type: "image/png"
        },
        {
          src: "/appimages/ios/152.png",
          sizes: "152x152",
          type: "image/png"
        },
        {
          src: "/appimages/ios/120.png",
          sizes: "120x120",
          type: "image/png"
        },
        # Windows icons
        {
          src: "/appimages/windows11/Square150x150Logo.scale-200.png",
          sizes: "300x300",
          type: "image/png"
        },
        {
          src: "/appimages/windows11/Square44x44Logo.targetsize-256.png",
          sizes: "256x256",
          type: "image/png"
        }
      ],
      shortcuts: [
        {
          name: "New Task",
          url: "/tasks/new",
          description: "Create a new task"
        },
        {
          name: "Calendar",
          url: "/calendar",
          description: "View calendar events"
        }
      ],
      screenshots: [
        {
          src: "/screenshots/tasks.png",
          sizes: "1280x720",
          type: "image/png",
          form_factor: "wide",
          label: "Tasks Overview"
        },
        {
          src: "/screenshots/calendar.png",
          sizes: "1280x720",
          type: "image/png",
          form_factor: "wide",
          label: "Calendar Integration"
        }
      ]
    }
  end
end