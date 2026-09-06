let
  ci-microvm = "age1p8ehqgacgmkn4e85y3awa44w8mrze88328v69ltxxrrjtsn4ascsd8rvzd";
in {
  "forgejo-runner-token.age".publicKeys = [ci-microvm];
}
