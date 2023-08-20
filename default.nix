{ lib
, stdenv
, fetchurl
, ncurses5
, zlib
}:

stdenv.mkDerivation rec {
  pname = "binutils-arm-embedded";
  version = "2.24";
  target = "arm-none-eabi";
  target-cpu = "coretex-m4";

  suffix = {
    x86_64-linux  = "x86_64_arm-linux";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = {
      x86_64-linux  = "sha256-5ejFvpZk5/f5bg0JkZEQq1rVl3lPWxgJhxF3oPDxQTc=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  output = [ ];

  dontPatchELF = true;
  dontStrip = true;

  buildInputs = [];

  configurePhase = ''
      ./configure --target=${target} --prefix=$out/ \
                  --with-cpu=${target-cpu} --disable-werror \
                  --with-no-thumb-interwork --with-mode=thumb
 '';

  buildPhase = ''
      make  all 2>&1 | tee ./binutils-build-logs.log
  '';

  installPhase = ''
      make  install 2>&1 | tee ./binutils-build-logs.log
  '';

  env = {
     MY_RVDT_PATH="/home/ronald/src/toolchain/build/binutils-build/result/bin"; 
     _PATH="/home/ronald/src/toolchain/build/binutils-build/result/bin";
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
