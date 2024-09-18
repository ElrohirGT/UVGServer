{
  self,
  ...
}: {
  users.users.flavio = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = let
      vimRice = self.inputs.flaviosConfiguration.outputs.packages.x86_64-linux.vim;
    in [vimRice];
  };
}
