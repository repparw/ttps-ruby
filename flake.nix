{
  description = "Ruby on Rails development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby_3_2
            sqlite
            nodejs_20
            yarn
            # Required dependencies for gem installation and native extensions
            pkg-config
            openssl
            libyaml
            libxml2
            libxslt
            zlib
            readline
            ncurses
            # Additional build tools that might be needed
            gnumake
            gcc
            automake
            autoconf
            libtool
          ];
          shellHook = ''
            export LANG=en_US.UTF-8

            # Set up Bundler configuration
            export BUNDLE_PATH="vendor/bundle"

            # Add Bundler bins to PATH
            export PATH="$PWD/bin:$PWD/vendor/bundle/ruby/3.2.0/bin:$PATH"

            # Install basic gems if they're not already installed
            if ! command -v bundle >/dev/null 2>&1; then
              echo "Installing bundler..."
              gem install bundler
            fi

            # Only install Rails if it's not already available in the bundle
            if ! [ -f "Gemfile" ] && ! command -v rails >/dev/null 2>&1; then
              echo "Installing Rails 8.0.0..."
              gem install rails -v 8.0.0
            fi

            # SQLite configuration
            export SQLITE_LIBS="-L${pkgs.sqlite.out}/lib -lsqlite3"
            export SQLITE_CFLAGS="-I${pkgs.sqlite.dev}/include"

            # Additional environment variables for native gem compilation
            export MAKEFLAGS="-j$NIX_BUILD_CORES"
            export BUNDLE_BUILD__NOKOGIRI="--use-system-libraries"

            echo "Ruby $(ruby -v) development environment ready!"
            if command -v rails >/dev/null 2>&1; then
              echo "Rails $(rails -v) is installed!"
            fi
            echo "Use 'bundle install' to install project dependencies"
          '';
        };
      }
    );
}
