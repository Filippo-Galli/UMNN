{
  pkgs,
  lib,
  buildPythonPackage ? pkgs.python3Packages.buildPythonPackage,
  hatchling ? pkgs.python3Packages.hatchling,
  numpy ? pkgs.python3Packages.numpy,
  torch ? pkgs.python3Packages.torch,
  matplotlib ? pkgs.python3Packages.matplotlib,
}:
let
  project = (lib.importTOML ./pyproject.toml).project;
in
buildPythonPackage rec {
  pname = project.name;
  version = project.version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.difference ./. (
      lib.fileset.unions [
        ./poster
        ./Presentation
        ./figures
        ./doc
        ./datasets
      ]
    );

  };

  pyproject = true;
  build-system = [
    hatchling
  ];

  dependencies = [
    numpy
    torch
  ];

  # Test that the package can be imported
  pythonImportsCheck = [ "UMNN" ];
  # tests
  doCheck = true;
  nativeCheckInputs = [
    pkgs.python3Packages.pytestCheckHook
    matplotlib
  ];
}
