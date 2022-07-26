{ lib }:
let
  pname = "apple-color-emoji";
  version = "55ef43bbeca8adfedc2f5db833ae85e8266b6157";
in
builtins.fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/ios-14.6/AppleColorEmoji.ttf";
  # sha256 = lib.fakeSha256;
  sha256 = "sha256:1hi9cgbgl7g728plm6lfqywmva0bn90wjjv7jmnnbwz1sfqq7c5i";
}
