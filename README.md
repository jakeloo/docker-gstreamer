# GStreamer in a Docker

It builds `glib`, `gobject-introspection` and `gstreamer`.


### Version
`os: ubuntu:20.04` (focal)

`glib: 2.64.4`

`gobject-introspection: 1.64.1`

`gstreamer: 1.17.2`


### Run
```
docker build -t gstreamer:base -f Dockerfile .
docker run -it gstreamer:base
```

To build gstreamer with CEF src plugin.
```
docker build -t gstreamer:base -f Dockerfile .
docker build -t gstreamer:cef -f Dockerfile.cef .
docker run -it gstreamer:cef

# cef needs x11 window :)
Xvfb :0 &
gst-launch-1.0 cefsrc url="https://jake.sh" ! cefdemux name=d d.video ! videoconvert ! queue ! pngenc ! queue ! multifilesink location="frame%d.png"
```

To build gstreamer with SRT src/sink plugin.
```
docker build -t gstreamer:base -f Dockerfile .
docker build -t gstreamer:srt -f Dockerfile.srt .
docker run -it gstreamer:srt

gst-launch-1.0 srtsrc ! srtsink
```
