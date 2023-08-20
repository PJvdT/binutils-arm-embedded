{ lib
, stdenv
, fetchurl
, ncurses5
, zlib
}:

stdenv.mkDerivation rec {
  pname = "binutils-arm-embedded";
  version = "2.24";

  suffix = {
    x86_64-linux  = "x86_64_arm-linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = {
      x86_64-linux  = "sha256-/e8QLnVLKqnn0LKtRlIWpBtCFpThzgzJcmISFPisS9U=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  output = [ "out" ];

  dontPatchELF = true;
  dontStrip = true;

  buildInputs = [];

  configurePhase = ''
      ../../binutils-2.24/configure --target=arm-linux-eabi --prefix=$out/arm-linux-eabi \
                                    --with-cpu=armv9-a --disable-werror \
                                    --with-no-thumb-interwork --with-mode=thumb
  '';

  buildPhase = ''
      make  all 2>&1 | tee ./binutils-build-logs.log
  '';

  installPhase = ''
      make  install 2>&1 | tee ./binutils-build-logs.log
  '';

  env = {
     MY_RVDT_PATH="/home/ronald/gcc-arm-embedded-4.9/result/bin/"; 
     _PATH="/home/ronald/gcc-arm-embedded-4.9/result/bin";
     DIRENV_DISABLE="true";
  } ; 

  meta = with lib; {
    description = "Build GNU toolchain from ARM Cortex-M & Cortex-R processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-rm";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ Ronald ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
