# GStreamer in a Docker

It builds `glib`, `gobject-introspection` and `gstreamer`.

### Version
`os: ubuntu:20.04` (focal)
`glib: 2.59.0`
`gobject-introspection: 1.59.5`
`gstreamer: 1.16.2`


### Run
```
docker build -t gstreamer:local .
docker run -it gstreamer:local
```
