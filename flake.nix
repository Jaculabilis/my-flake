{
  description = "A semi-verbose flake format helper.";

  outputs = { self }:
  let
    inherit (builtins) elemAt foldl' head isAttrs length map zipAttrsWith;

    # Copied from <nixpkgs/lib/attrsets.nix> to avoid taking a dependency
    recursiveUpdateUntil = pred: lhs: rhs:
      let f = attrPath:
        zipAttrsWith (n: values:
          let here = attrPath ++ [n];
          in
            if length values == 1 || pred here (elemAt values 1) (head values)
            then head values
            else f here values
        );
      in f [] [rhs lhs];
    recursiveUpdate = lhs: rhs:
      recursiveUpdateUntil (path: lhs: rhs: !(isAttrs lhs && isAttrs rhs)) lhs rhs;
  in
  {
    /* Create the flake outputs for systems and merge them into the expected format.

       system-outputs: function from a system to the flake outputs for that system.
       systems: a list of systems to produce flake outputs for.
    */
    outputs-for = system-outputs: systems: foldl' recursiveUpdate {} (map system-outputs systems);

    templates = {
      basic = {
        path = ./templates/basic;
        description = "A basic flake config using my-flake.";
      };
      default = self.templates.basic;
    };
  };
}
