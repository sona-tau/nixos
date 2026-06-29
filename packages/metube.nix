{
	lib,
	stdenvNoCC,
	fetchFromGitHub,
	python313,
	makeWrapper,
	ffmpeg,
	nodejs,
	pnpm_9,
	fetchPnpmDeps,
	pnpmConfigHook,
}:

let
	pnpm = pnpm_9;

	src = fetchFromGitHub {
		owner = "alexta69";
		repo = "metube";
		rev = "ce897ee00903bf7ded406f0d7852d95dd4164add";
		hash = "sha256-wCWhND0lHBmfjPVOvdeL1q4/cT0ixiLk4RncY/OCm30=";
	};

	pythonEnv = python313.withPackages (ps: with ps; [
		aiohttp
		python-socketio
		yt-dlp
		mutagen
		curl-cffi
		watchfiles
	]);

	# Build the Angular frontend from source.
	# The pnpm deps hash below must be computed once:
	#   nix build .#packages.x86_64-linux.metube 2>&1 | grep 'got:'
	# then replace lib.fakeHash with the printed sha256-... value.
	ui = stdenvNoCC.mkDerivation {
		pname = "metube-ui";
		version = "2026.06.20";
		inherit src;
		sourceRoot = "source/ui";

		pnpmDeps = fetchPnpmDeps {
			pname = "metube-ui";
			inherit src;
			sourceRoot = "source/ui";
			pnpm = pnpm_9;
			fetcherVersion = 1;
			hash = lib.fakeHash;
		};

		nativeBuildInputs = [ nodejs pnpm pnpmConfigHook ];

		buildPhase = ''
			runHook preBuild
			pnpm run build
			runHook postBuild
		'';

		installPhase = ''
			runHook preInstall
			cp -r dist/metube $out
			runHook postInstall
		'';
	};

in stdenvNoCC.mkDerivation {
	pname = "metube";
	version = "2026.06.20";
	inherit src;

	nativeBuildInputs = [ makeWrapper ];

	dontBuild = true;
	dontConfigure = true;

	installPhase = ''
		runHook preInstall

		mkdir -p $out/share/metube/ui/dist
		cp -r app $out/share/metube/
		cp -r ${ui} $out/share/metube/ui/dist/metube

		mkdir -p $out/bin
		makeWrapper ${pythonEnv}/bin/python3 $out/bin/metube \
			--add-flags "$out/share/metube/app/main.py" \
			--set BASE_DIR "$out/share/metube" \
			--set PYTHONPATH "$out/share/metube/app" \
			--prefix PATH : "${ffmpeg}/bin"

		runHook postInstall
	'';

	meta = {
		description = "Web GUI for yt-dlp with a download queue";
		homepage = "https://github.com/alexta69/metube";
		license = lib.licenses.agpl3Only;
		mainProgram = "metube";
		platforms = lib.platforms.linux;
	};
}
