{ stdenvNoCC, fetchurl }: stdenvNoCC.mkDerivation {
	pname = "catppuccin-gitea";
	version = "1.0.2";

	src = fetchurl {
		url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
		hash = "sha256-HP4Ap4l2K1BWP1zWdCKYS5Y5N+JcKAcXi+Hx1g6MVwc=";
	};

	sourceRoot = ".";
	dontBuild = true;

	installPhase = ''
		mkdir -p $out
		cp *.css $out/
	'';
}
