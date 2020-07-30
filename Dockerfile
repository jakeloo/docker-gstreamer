FROM ubuntu:20.04

WORKDIR /gstreamer

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get -y install \
      python3.8 python3.8-dev python3-distutils python3-pip \
      libmount-dev bison flex pkg-config autotools-dev libffi-dev \
      librtmp-dev libx264-dev libsoup2.4-1 libsoup2.4-dev libpng-dev \
      build-essential ninja-build git xvfb cmake

# nvidia gpu support
# ENV NVIDIA_DRIVER_CAPABILITIES=all
# RUN apt-get -y install libnvidia-gl-390 libnvidia-decode-390 libnvidia-encode-390 libgl1-mesa-dev libgl1-mesa-glx

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 9
RUN update-alternatives --set python3 /usr/bin/python3.8

RUN python3 -m pip install meson

ARG GLIB_VERSION=2.64.4
RUN git clone https://github.com/GNOME/glib.git && \
      cd glib && \
      git checkout $GLIB_VERSION && \
      meson build && \
      ninja -C build install

ARG GOBJECT_INTROSPECTION_VERSION=1.64.1
RUN git clone https://github.com/GNOME/gobject-introspection.git && \
      cd gobject-introspection && \
      git checkout $GOBJECT_INTROSPECTION_VERSION && \
      meson build && \
      ninja -C build install

ARG GST_BUILD_VERSION=1.17.2
RUN git clone https://github.com/gstreamer/gst-build.git && \
    cd gst-build && \
    git checkout $GST_BUILD_VERSION

ARG GST_VERSION=1.17.2
RUN cd ./gst-build && \
    meson build/ && \
    ./gst-worktree.py add gst-build-$GST_VERSION $GST_VERSION

RUN cd ./gst-build/gst-build-$GST_VERSION && \
    meson build \
        -Dintrospection=enabled \
        -Dexamples=disabled \
        -Dgtk_doc=disabled \
        -Dbenchmarks=disabled \
        -Dgstreamer:tests=disabled \
        -Dgstreamer:benchmarks=disabled \
        -Dgst-plugins-base:tests=disabled \
        -Dgst-plugins-good:tests=disabled \
        -Dgst-plugins-bad:tests=disabled \
        -Dgst-plugins-ugly:tests=disabled \
        -Dgst-plugins-base:gl=disabled \
        -Dgst-plugins-bad:nvdec=disabled \
        -Dgi=disabled \
        -Dpython=enabled \
        -Dpygobject=enabled \
        -Dpygobject:pycairo=false

RUN cd ./gst-build/gst-build-$GST_VERSION && \
    ninja -C build install

ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu:/usr/local/lib:${LD_LIBRARY_PATH}
ENV GI_TYPELIB_PATH=/usr/lib/x86_64-linux-gnu/girepository-1.0:/usr/local/lib/x86_64-linux-gnu/girepository-1.0

