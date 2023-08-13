{ pkgs }:
{
  allowUnfree = true; 
  environment.systemPackages = with pkgs; [
    (brave.override { 
      environment = {
        LIBVA_DRI3_DISABLE = "1";
        LIBVA_DRIVER_NAME = "iHD";
        };
      commandLineArgs = [
      "--enable-blink-features=MiddleClickAutoscroll"
      "--disable-features=EnableTabMuting"
      ];
    })
  ];
nixpkgs.config.brave.commandLineArgs = "--enable-blink-features=MiddleClickAutoscroll";
}
