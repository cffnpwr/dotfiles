let
  ageKey = "age1x0v0aahyqnhn3m3kp204ek530kky03z2vhyxs7evnrk0a4g0gs9sv2ad35";

  publicKeys = [ ageKey ];
in
{
  "github-token.age".publicKeys = publicKeys;
}
