# srt

SRT_VERSION := 1.4.2
SRT_URL := $(GITHUB)/Haivision/srt/archive/v$(SRT_VERSION).tar.gz

ifdef BUILD_NETWORK
PKGS += srt
endif

ifeq ($(call need_pkg,"srt >= 1.3.1"),)
PKGS_FOUND += srt
endif

SRT_CFLAGS   := $(CFLAGS) $(PIC)
SRT_CXXFLAGS := $(CXXFLAGS) $(PIC)
DEPS_srt = gnutls $(DEPS_gnutls)
ifdef HAVE_WIN32
DEPS_srt += pthreads $(DEPS_pthreads)
endif


$(TARBALLS)/srt-$(SRT_VERSION).tar.gz:
	$(call download_pkg,$(SRT_URL),srt)

.sum-srt: srt-$(SRT_VERSION).tar.gz

srt: srt-$(SRT_VERSION).tar.gz .sum-srt
	$(UNPACK)
	$(APPLY) $(SRC)/srt/0001-core-ifdef-MSG_TRUNC-nixes-fix.patch
	$(APPLY) $(SRC)/srt/fix-gcc11-build.patch
	$(call pkg_static,"scripts/srt.pc.in")
	mv srt-$(SRT_VERSION) $@ && touch $@

.srt: srt toolchain.cmake
	cd $< && $(HOSTVARS_PIC) CFLAGS="$(SRT_CFLAGS)" CXXFLAGS="$(SRT_CXXFLAGS)" $(CMAKE) \
		-DENABLE_SHARED=OFF -DUSE_GNUTLS=ON -DENABLE_CXX11=OFF -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_INSTALL_BINDIR=bin -DCMAKE_INSTALL_INCLUDEDIR=include
	cd $< && $(CMAKEBUILD) . --target install
	touch $@
