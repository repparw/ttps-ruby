{
<<<<<<< HEAD
  description = "A simple ruby app demo";

  nixConfig = {
    extra-substituters = "https://nixpkgs-ruby.cachix.org";
    extra-trusted-public-keys = "nixpkgs-ruby.cachix.org-1:vrcdi50fTolOxWCZZkw0jakOnUI1T19oYJ+PRYdK4SM=";
  };

  inputs = {
    nixpkgs.url = "nixpkgs";
    ruby-nix.url = "github:inscapist/ruby-nix";
    # a fork that supports platform dependant gem
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fu.url = "github:numtide/flake-utils";
    bob-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    bob-ruby.inputs.nixpkgs.follows = "nixpkgs";
  };

=======
  description = "Ruby on Rails development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
>>>>>>> 56952c8 (rails new, initial setup)
  outputs =
    {
      self,
      nixpkgs,
<<<<<<< HEAD
      fu,
      ruby-nix,
      bundix,
      bob-ruby,
    }:
    with fu.lib;
    eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ bob-ruby.overlays.default ];
        };
        rubyNix = ruby-nix.lib pkgs;

        # TODO generate gemset.nix with bundix
        gemset = if builtins.pathExists ./gemset.nix then import ./gemset.nix else { };

        # If you want to override gem build config, see
        #   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem-config/default.nix
        gemConfig = { };

        # See available versions here: https://github.com/bobvanderlinden/nixpkgs-ruby/blob/master/ruby/versions.json
        ruby = pkgs."ruby-3.3.1";

        # Running bundix would regenerate `gemset.nix`
        bundixcli = bundix.packages.${system}.default;

        # Use these instead of the original `bundle <mutate>` commands
        bundleLock = pkgs.writeShellScriptBin "bundle-lock" ''
          export BUNDLE_PATH=vendor/bundle
          bundle lock
        '';
        bundleUpdate = pkgs.writeShellScriptBin "bundle-update" ''
          export BUNDLE_PATH=vendor/bundle
          bundle lock --update
        '';
      in
      rec {
        inherit
          (rubyNix {
            inherit gemset ruby;
            name = "my-rails-app";
            gemConfig = pkgs.defaultGemConfig // gemConfig;
          })
          env
          ;

        devShells = rec {
          default = dev;
          dev = pkgs.mkShell {
            buildInputs =
              [
                env
                bundixcli
                bundleLock
                bundleUpdate
              ]
              ++ (with pkgs; [
                yarn
                rufo
              ]);
          };
=======
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
            export PATH="$PWD/bin:$GEM_HOME/ruby/*/bin:$PATH"

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
>>>>>>> 56952c8 (rails new, initial setup)
        };
      }
    );
}
