{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    optional
    types
    ;
  kernel = config.boot.kernelPackages.kernel;
  # cfg = config.hardware.ipu7;
  ipu7-drivers = config.boot.kernelPackages.callPackage ({
    stdenv,
    kernelModuleMakeFlags,
    lib,
    fetchFromGitHub,
  }:
    stdenv.mkDerivation rec {
      pname = "ipu7-drivers";
      version = "20250921_1733_232_PTL_Beta_IoT";
      src = fetchFromGitHub {
        owner = "intel";
        repo = "ipu7-drivers";
        rev = "62a3704433c35d3bdfa679fc4dee74e133ce815c";
        hash = "sha256-jScMYJAYtw9M4w+jyIBOF1JxO1Hv/EYWNI6I4B/8I9g=";
      };
      # REVIEW
      # patches = [
      #   "${src}/patches/0001-v6.10-IPU7-headers-used-by-PSYS.patch"
      # ];
      postPatch = ''
        cp --no-preserve=mode --recursive --verbose \
          ${config.boot.kernelPackages.ivsc-driver.src}/backport-include \
          ${config.boot.kernelPackages.ivsc-driver.src}/drivers \
          ${config.boot.kernelPackages.ivsc-driver.src}/include \
          .
      '';
      nativeBuildInputs = kernel.moduleBuildDependencies;
      makeFlags =
        kernelModuleMakeFlags
        ++ [
          "KERNELRELEASE=${kernel.modDirVersion}"
          "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        ];
      enableParallelBuilding = true;
      preInstall = ''
        sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," Makefile
      '';
      installTargets = [
        "modules_install"
      ];
      meta = {
        homepage = "https://github.com/intel/ipu7-drivers";
        description = "IPU7 kernel driver";
        license = lib.licenses.gpl2Only;
        maintainers = [];
        platforms = ["x86_64-linux"];
        # REVIEW
        # requires 6.10
        broken = kernel.kernelOlder "6.10";
      };
    }) {};
  ipu7-camera-bins = config.boot.kernelPackages.callPackage ({
    lib,
    stdenv,
    fetchFromGitHub,
    autoPatchelfHook,
    expat,
    zlib,
  }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "ipu7-camera-bins";
      version = "20250921_1733_232_PTL_Beta_IoT";
      src = fetchFromGitHub {
        repo = "ipu7-camera-bins";
        owner = "intel";
        rev = "09ccd020d5d1aa34b91e9f30b01a4166dd31f51b";
        hash = "sha256-d/WtM7oiq6zDQ5nLGqOFcjWDTLOSShPDYdC+wog3zbY=";
      };
      nativeBuildInputs = [
        autoPatchelfHook
        (lib.getLib stdenv.cc.cc)
        expat
        zlib
      ];
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp --no-preserve=mode --recursive \
          lib \
          include \
          $out/
        # REVIEW file exists now
        # There is no LICENSE file in the src
        # install -m 0644 -D LICENSE $out/share/doc/LICENSE
        runHook postInstall
      '';
      postFixup = ''
        for lib in $out/lib/lib*.so.*; do \
          lib=''${lib##*/}; \
          target=$out/lib/''${lib%.*}; \
          if [ ! -e "$target" ]; then \
            ln -s "$lib" "$target"; \
          fi \
        done
        for pcfile in $out/lib/pkgconfig/*.pc; do
          substituteInPlace $pcfile \
            --replace 'prefix=/usr' "prefix=$out"
        done
      '';
      meta = with lib; {
        description = "IPU firmware and proprietary image processing libraries";
        homepage = "https://github.com/intel/ipu7-camera-bins";
        license = licenses.issl;
        sourceProvenance = with sourceTypes; [
          binaryFirmware
        ];
        maintainers = [];
        platforms = ["x86_64-linux"];
      };
    })) {};
  icamerasrc-ipu7x = icamerasrc {
    ipu6-camera-hal = ipu7x-camera-hal;
  };
  icamerasrc-ipu75xa = icamerasrc {
    ipu6-camera-hal = ipu75xa-camera-hal;
  };
  icamerasrc =
    config.boot.kernelPackages.callPackage
    ({
      lib,
      stdenv,
      fetchFromGitHub,
      autoreconfHook,
      pkg-config,
      gst_all_1,
      ipu6-camera-hal,
      libdrm,
      libva,
    }:
      stdenv.mkDerivation {
        pname = "icamerasrc-${ipu6-camera-hal.ipuVersion}";
        version = "unstable-2025-09-26";
        src = fetchFromGitHub {
          owner = "intel";
          repo = "icamerasrc";
          rev = "4fb31db76b618aae72184c59314b839dedb42689";
          hash = "sha256-BYURJfNz4D8bXbSeuWyUYnoifozFOq6rSfG9GBKVoHo=";
        };
        nativeBuildInputs = [
          autoreconfHook
          pkg-config
        ];
        preConfigure = ''
          # https://github.com/intel/ipu6-camera-hal/issues/1
          export CHROME_SLIM_CAMHAL=ON
          # https://github.com/intel/icamerasrc/issues/22
          export STRIP_VIRTUAL_CHANNEL_CAMHAL=ON
        '';
        buildInputs = [
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-bad
          ipu6-camera-hal
          libdrm
          libva
        ];
        NIX_CFLAGS_COMPILE = [
          "-Wno-error"
          # gstcameradeinterlace.cpp:55:10: fatal error: gst/video/video.h: No such file or directory
          "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
        ];
        enableParallelBuilding = true;
        passthru = {
          inherit (ipu6-camera-hal) ipuVersion;
        };
        meta = with lib; {
          description = "GStreamer Plugin for MIPI camera support through the IPU6/IPU6EP/IPU6SE on Intel Tigerlake/Alderlake/Jasperlake platforms";
          homepage = "https://github.com/intel/icamerasrc/tree/icamerasrc_slim_api";
          license = licenses.lgpl21Plus;
          maintainers = [];
          platforms = ["x86_64-linux"];
        };
      });
  ipu7x-camera-hal = camera-hal {
    ipuVersion = "ipu7x";
  };
  ipu75xa-camera-hal = camera-hal {
    ipuVersion = "ipu75xa";
  };
  camera-hal = config.boot.kernelPackages.callPackage ({
    lib,
    stdenv,
    fetchFromGitHub,
    # build
    cmake,
    pkg-config,
    # runtime
    expat,
    jsoncpp,
    libtool,
    gst_all_1,
    libdrm,
    # Pick one of
    # - ipu7x (Lunar Lake)
    # - ipu75xa (Lunar Lake)
    ipuVersion ? "ipu7x",
  }: let
    ipuTarget =
      {
        "ipu7x" = "ipu_lnl";
        "ipu75xa" = "ipu_lnl";
      }
      .${
        ipuVersion
      };
  in
    stdenv.mkDerivation {
      pname = "${ipuVersion}-camera-hal";
      version = "unstable-2025-10-17";
      src = fetchFromGitHub {
        owner = "intel";
        repo = "ipu7-camera-hal";
        rev = "ec24db24bc3400c60a62ecd6b10f263ecbb11b2e";
        hash = "sha256-QQoKkKJAlQxrueusi7WsTN4besVq34L1uujPZ0pmhPA=";
      };
      nativeBuildInputs = [
        cmake
        pkg-config
      ];
      cmakeFlags = [
        "-DCMAKE_BUILD_TYPE=Release"
        "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
        "-DCMAKE_INSTALL_LIBDIR=lib"
        "-DCMAKE_INSTALL_INCLUDEDIR=include"
        "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        "-DBUILD_CAMHAL_ADAPTOR=ON"
        "-DBUILD_CAMHAL_PLUGIN=ON"
        "-DIPU_VERSIONS=${ipuVersion}"
        "-DUSE_STATIC_GRAPH=ON"
        "-DUSE_STATIC_GRAPH_AUTOGEN=ON"
      ];
      NIX_CFLAGS_COMPILE = [
        "-Wno-error"
      ];
      enableParallelBuilding = true;
      buildInputs = [
        expat
        ipu7-camera-bins
        jsoncpp
        libtool
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        libdrm
      ];
      postPatch = ''
        substituteInPlace src/platformdata/JsonParserBase.h \
          --replace-fail '<jsoncpp/json/json.h>' '<json/json.h>'
      '';
      postInstall = ''
        mkdir -p $out/include/${ipuTarget}/
        cp -r $src/include $out/include/${ipuTarget}/libcamhal
      '';
      postFixup = ''
        for lib in $out/lib/*.so; do
          patchelf --add-rpath "${ipu7-camera-bins}/lib" $lib
        done
      '';
      passthru = {
        inherit ipuVersion ipuTarget;
      };
      meta = with lib; {
        description = "HAL for processing of images in userspace";
        homepage = "https://github.com/intel/ipu7-camera-hal";
        license = licenses.asl20;
        maintainers = [];
        platforms = ["x86_64-linux"];
      };
    });
in {
  # Module is upstream as of 6.17,
  # https://www.phoronix.com/news/Intel-IPU7-Firmware-Upstreamed
  boot.extraModulePackages = [ipu7-drivers];
  hardware.firmware = [
    ipu7-camera-bins
    pkgs.ivsc-firmware
  ];
  services.udev.extraRules = ''
    SUBSYSTEM=="intel-ipu7-psys", MODE="0660", GROUP="video"
  '';
  services.v4l2-relayd.instances.ipu7 = {
    enable = mkDefault true;
    cardLabel = mkDefault "Intel MIPI Camera";
    extraPackages = [
      icamerasrc-ipu7x
      # icamerasrc-ipu75xa
    ];
    input = {
      pipeline = "icamerasrc";
      # REVIEW from https://edc.intel.com/content/www/us/en/secure/design/confidential/products/platforms/details/lunar-lake-mx/core-ultra-200v-series-processors-datasheet-volume-1-of-2/camera-integrated-isp/
      # Output Formats - NV12, NV16, I420, M420, YUY2, YUYV, P010, P016
      # format = mkIf (cfg.platform != "ipu7") (mkDefault "NV12");
    };
  };
}
