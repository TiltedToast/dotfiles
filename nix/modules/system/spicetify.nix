{ inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      {
        src =
          (pkgs.fetchFromGitHub {
            owner = "41pha1";
            repo = "spicetify-extensions";
            rev = "5015b9122a9c39274bdc7507e1de4fec0cc20f95";
            hash = "sha256-JkkIs40Kp57kLTcb95WIgfHDoCP/LHZ3TmdP1w1e1OY=";
          })
          + "/romaji-lyrics";
        name = "romaji_lyrics.js";
      }
      {
        src =
          (pkgs.fetchFromGitHub {
            owner = "resxt";
            repo = "spicetify-extensions";
            rev = "75bd17ba1c9a19730f14529fb18857d7b9c7c12e";
            hash = "sha256-+Th5o00c3Y8U+Y/RGmRSkWWp97YCoCJmoESFLZf9dwM=";
          })
          + "/startup-page/dist";
        name = "startup-page.js";
      }
      fullAlbumDate
      shuffle
      seekSong
      keyboardShortcut
      fullAlbumDate
    ];

    enabledCustomApps = with spicePkgs.apps; [
      historyInSidebar
      marketplace

      {
        src = pkgs.fetchzip {
          url = "https://github.com/harbassan/spicetify-apps/releases/download/stats-v1.1.2/spicetify-stats.release.zip";
          hash = "sha256-lIWAJDO/2fZEzBmK79wdB9H78+4A1xOw90Zy4e4ql4s=";
        };
        name = "index.js";
      }
    ];

    enabledSnippets = with spicePkgs.snippets; [
      roundedButtons
      smoothPlaylistRevealGradient
      prettyLyrics
      fixMainViewWidth
      roundedImages
    ];

    theme = spicePkgs.themes.lucid;
  };
}
