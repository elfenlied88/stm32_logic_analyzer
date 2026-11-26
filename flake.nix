{
  description = "STM32F103C8T6 logic analyzer: firmware (CMake + arm-none-eabi) and hardware (KiCad)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "stm32f103-logic-analyzer";

        packages = with pkgs; [
          gcc-arm-embedded # arm-none-eabi-gcc/g++, objcopy, size, ...
          cmake
          ninja
          gnumake

          openocd
          stlink # st-flash, st-util
          dfu-util
          stm32flash # UART bootloader flashing
        ];

        shellHook = ''
          # clangd needs compile_commands.json; make CMake always generate it
          export CMAKE_EXPORT_COMPILE_COMMANDS=ON

          echo "STM32 dev shell: $(arm-none-eabi-gcc --version | head -n1)"
          echo "Build:  cd firmware/logic_analyzer_sw && cmake --list-presets"
        '';
      };
    };
}
