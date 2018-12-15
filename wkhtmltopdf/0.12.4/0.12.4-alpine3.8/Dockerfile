FROM alpine:3.8 as build-wkhtmltopdf

# Copying QT patches to /tmp
COPY conf/* /tmp/qt/

# Adding edge/testing repository to source list updating packages list
# and installing packages required to build QT/wkhtmltopdf
RUN apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	    gtk+ openssl glib fontconfig bash vim git patch make g++ \
		libc-dev gettext-dev zlib-dev bzip2-dev libffi-dev pcre-dev \
		glib-dev atk-dev expat-dev libpng-dev freetype-dev fontconfig-dev \
		libxau-dev libxdmcp-dev libxcb-dev xf86bigfontproto-dev libx11-dev \
		libxrender-dev pixman-dev libxext-dev cairo-dev perl-dev \
		libxfixes-dev libxdamage-dev graphite2-dev icu-dev harfbuzz-dev \
		libxft-dev pango-dev gtk+-dev libdrm-dev \
		libxxf86vm-dev libxshmfence-dev wayland-dev mesa-dev openssl-dev

# We clone wkhtmltopdf repo (without history) and with QT submodule
RUN git clone --verbose --recurse-submodules --progress --depth 1 --branch 0.12.4 --single-branch https://github.com/wkhtmltopdf/wkhtmltopdf.git /tmp/wkhtmltopdf \
	# Copying the previously added patches into QT submodule path a removing the original folder
	&& cp /tmp/qt/* /tmp/wkhtmltopdf/qt/ && rm -rf /tmp/qt

# Moving into QT submodule path and applying patches
RUN cd /tmp/wkhtmltopdf/qt && \
	patch -p1 -i qt-musl.patch && \
	patch -p1 -i qt-musl-iconv-no-bom.patch && \
	patch -p1 -i qt-recursive-global-mutex.patch && \
	patch -p1 -i qt-font-pixel-size.patch && \
	patch -p1 -i qt-gcc6.patch && \
	# Configuring, compiling and installing patched QT
	sed -i "s|-O2|$CXXFLAGS|" mkspecs/common/g++.conf && \
	sed -i "/^QMAKE_RPATH/s| -Wl,-rpath,||g" mkspecs/common/g++.conf && \
	sed -i "/^QMAKE_LFLAGS\s/s|+=|+= $LDFLAGS|g" mkspecs/common/g++.conf && \
	CFLAGS=-w CPPFLAGS=-w CXXFLAGS=-w LDFLAGS=-w \
	./configure -confirm-license -opensource \
		-prefix /usr \
		-datadir /usr/share/qt \
		-sysconfdir /etc \
		-plugindir /usr/lib/qt/plugins \
		-importdir /usr/lib/qt/imports \
		-fast -release -static -largefile -glib -graphicssystem raster \
		-qt-zlib -qt-libpng -qt-libmng -qt-libtiff -qt-libjpeg \
		-svg -script -webkit -gtkstyle -xmlpatterns -script -scripttools -openssl-linked \
		-nomake demos -nomake docs -nomake examples -nomake tools -nomake tests -nomake translations -no-qt3support \
		-no-pch -no-icu -no-phonon -no-phonon-backend -no-rpath -no-separate-debug-info -no-dbus -no-opengl -no-openvg && \
	NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
	export MAKEFLAGS=-j${NPROC} && \
	export MAKE_COMMAND="make -j${NPROC}" && \
	make --silent && \
	make install && \
	# Configuring, compiling and installing wkhtmltopdf 0.12.4
	cd /tmp/wkhtmltopdf && \
	qmake && \
	make --silent && \
	make install

# ! wkhtmltopdf 0.12.4 with patched QT takes ~20m to compiles on a Intel i5-6600K
#
# To reduce size of the final image, wkhtmltopdf is built into a
# multi-stages build. The resulting binary is passed into a
# fresh alpine image and only required librairies needed
# to run wkhtmltopdf are installed.
FROM alpine:3.8
RUN apk add --update --no-cache \
        libgcc libstdc++ libx11 libxrender libxext glib libcrypto1.0 libssl1.0
WORKDIR /usr/bin/
COPY --from=build-wkhtmltopdf /bin/wkhtmltopdf .
ENTRYPOINT ["wkhtmltopdf"]
