FROM alpine:3.14 as build-wkhtmltopdf

LABEL maintainer="Jean Traullé <jean@opencomp.fr>"

# Environment variables
ENV WKHTMLTOX_VERSION=0.12.6

# Copy patches
RUN mkdir -p /tmp/patches
COPY conf/* /tmp/patches/

# Install needed packages
RUN apk add --no-cache \
    libstdc++ libx11 libxrender libxext libssl1.1 ca-certificates fontconfig freetype \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation \
&& apk add --no-cache --virtual .build-deps \
   g++==8.3.0-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main \
   git gtk+ gtk+-dev make mesa-dev openssl-dev patch fontconfig-dev freetype-dev \
\
# Download source files
&& git clone --recursive https://github.com/wkhtmltopdf/wkhtmltopdf.git /tmp/wkhtmltopdf \
&& cd /tmp/wkhtmltopdf \
&& git checkout tags/$WKHTMLTOX_VERSION \
\
# Apply patches
&& cd /tmp/wkhtmltopdf/qt \
&& patch -p1 -i /tmp/patches/qt-musl.patch \
&& patch -p1 -i /tmp/patches/qt-musl-iconv-no-bom.patch \
&& patch -p1 -i /tmp/patches/qt-recursive-global-mutex.patch \
&& patch -p1 -i /tmp/patches/qt-gcc6.patch \
\
# Modify qmake config
&& sed -i "s|-O2|$CXXFLAGS|" mkspecs/common/g++.conf \
&& sed -i "/^QMAKE_RPATH/s| -Wl,-rpath,||g" mkspecs/common/g++.conf \
&& sed -i "/^QMAKE_LFLAGS\s/s|+=|+= $LDFLAGS|g" mkspecs/common/g++.conf \
\
# Prepare optimal build settings
&& NB_CORES=$(grep -c '^processor' /proc/cpuinfo) \
\
# Install qt
&& ./configure -confirm-license -opensource \
  -prefix /usr \
  -datadir /usr/share/qt \
  -sysconfdir /etc \
  -plugindir /usr/lib/qt/plugins \
  -importdir /usr/lib/qt/imports \
  -silent -release -static \
  -webkit -script -svg -exceptions -xmlpatterns -openssl-linked \
  -no-fast -no-largefile -no-accessibility -no-stl -no-sql-ibase -no-sql-mysql -no-sql-odbc -no-sql-psql \
  -no-sql-sqlite -no-sql-sqlite2 -no-qt3support -no-opengl -no-openvg -no-system-proxies -no-multimedia \
  -no-audio-backend -no-phonon -no-phonon-backend -no-javascript-jit -no-scripttools -no-declarative \
  -no-declarative-debug -no-mmx -no-3dnow -no-sse -no-sse2 -no-sse3 -no-ssse3 -no-sse4.1 -no-sse4.2 -no-avx \
  -no-neon -no-rpath -no-nis -no-cups -no-pch -no-dbus -no-separate-debug-info -no-gtkstyle -no-nas-sound \
  -no-opengl -no-openvg -no-sm -no-xshape -no-xvideo -no-xsync -no-xinerama -no-xcursor -no-xfixes -no-xrandr \
  -no-mitshm -no-xinput -no-xkb -no-glib -no-icu \
  -nomake demos -nomake docs -nomake examples -nomake tools -nomake tests -nomake translations \
  -graphicssystem raster \
  -qt-zlib -qt-libpng -qt-libmng -qt-libtiff -qt-libjpeg \
  -optimized-qmake -iconv -xrender -fontconfig -D ENABLE_VIDEO=0 \
&& make --jobs $(($NB_CORES*2)) --silent \
&& make install \
\
# Install wkhtmltopdf
&& cd /tmp/wkhtmltopdf \
&& qmake \
&& make --jobs $(($NB_CORES*2)) --silent \
&& make install \
&& make clean \
&& make distclean \
\
# Uninstall qt
&& cd /tmp/wkhtmltopdf/qt \
&& make uninstall \
&& make clean \
&& make distclean \
\
# Clean up when done
&& rm -rf /tmp/* \
&& apk del .build-deps

# Image
FROM alpine:3.14

RUN apk -U upgrade && apk add --no-cache \
    libstdc++ libx11 libxrender libxext libssl1.1 ca-certificates

COPY --from=build-wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf

ENTRYPOINT ["wkhtmltopdf"]
