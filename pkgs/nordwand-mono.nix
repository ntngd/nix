{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "nordwand-mono";
  version = "main";

  src = fetchFromGitHub {
    owner = "tywr";
    repo = "Nordwand-Mono";
    rev = "main";
    # Leave empty or set a fake hash to obtain the correct hash on first evaluation
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  # Since the repository includes pre-built fonts in the fonts/ directory:
  installPhase = ''
    runHook preInstall
    install -Dm644 fonts/*.ttf -t $out/share/fonts/truetype/
    install -Dm644 fonts/*.woff2 -t $out/share/fonts/woff2/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A compact monospace neo-grotesque font designed for developers";
    homepage = "https://github.com/tywr/Nordwand-Mono";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
