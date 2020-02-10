# GStreamer in a Docker

Running on Ubuntu:20.04 (focal).
It builds `glib`, `gobject-introspection` and `gstreamer`.

```
docker build -t gstreamer:local .
docker run -it gstreamer:local
```
