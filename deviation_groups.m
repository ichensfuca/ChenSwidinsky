
// load group data from Rouse-Zureick-Brown
load "gl2data.txt";
load "curvelist1.txt";

// initialize small group database
DB:=SmallGroupDatabase();

// problematic groups of order 192, 128, 96
G192a:=SmallGroup(DB,192,1023);
G192b:=SmallGroup(DB,192,1025);
G192c:=SmallGroup(DB,192,1541);
G128a:=SmallGroup(DB,128,2326);
G128b:=SmallGroup(DB,128,2327);
G128c:=SmallGroup(DB,128,2328);
G96a:=SmallGroup(DB,96,204);
problematic_groups:=[G192a, G192b, G192c, G128a, G128b, G128c, G96a];


S:=MatrixAlgebra(Integers(),2);

// residual group
function residual_group(G);
  assert IsDivisibleBy(Modulus(CoefficientRing(G2)),2);
  G2:=GL(2,Integers(2));
  GG:=[G2!S!g : g in SetToSequence(Generators(G))];
  RG:=sub< G2 | GG >;

  return RG;
end function;


// check if problematic groups are not quotients of G
function not_quotient(G);

normal_pass:=[];
for H in problematic_groups do
  sizegroup:=#H;
  normal_list:=[N : N in NormalSubgroups(G) | #G mod sizegroup eq 0 and Order(N`subgroup) eq Integers()!(#G/sizegroup)];

  normal_pass:=normal_pass cat [N : N in normal_list | IsIsomorphic(G/N`subgroup,H)];
end for;

return normal_pass eq [];
end function;


// curvelist1 has the labels of the 202 groups containing -I and having infinitely many Q-rational points
// run through these and compute the deviation group of E and a twist E' of E which is inner
for c in [1..#curvelist1] do

// get group label
i:=curvelist1[c][1];

// get the current group and its level
G2:=newsublist[i][3];
N2:=Modulus(CoefficientRing(G2));

// no need to consider if the group has genus \ge 2
if newsublist[i][5] notin [0,1] then
  printf "Group # %o, Level %o (genus >= 2) \n", i, N2;
  continue;
end if;

// no need to consider if the residual group is absolutely irreducible
if #residual_group(G2) eq 6 then
  printf "Group # %o, Level %o (absolutely irreducible) \n", i, N2;
  continue;
end if;

// no need to consider if the residual group is reducible
if #residual_group(G2) in [1,2] then
  printf "Group # %o, Level %o (reducible) \n", i, N2;
  continue;
end if;

// if the level is 1 or 2, increase to 4
N2:=Maximum(4,N2);

// double the level N2
O2:=GL(2,Integers(N2*2));

// work in the group with level N2*2 by adding in lifts of generators at level N2 and generators for the elements congruent to I mod N2
GG1:=[O2!S!g : g in SetToSequence(Generators(G2))];

GG2:=[O2![1+a*N2,b*N2,c*N2,1+d*N2] : a,b,c,d in [0..1]];
H:=sub< O2 | GG2>;
assert #H eq 16;

GG:=GG1 cat GG2;
G:=sub< O2 | GG >;

printf "Group # %o, Group Order %o, Lifted Level %o \n", i, #G, N2*2;
flag:=not_quotient(G);
assert flag;

end for;


// this implies of the 202 possibilities for \rhobar_{E,2}(G) containing -I and having infinitely many Q-rational points,
// none of these have a quotient isomorphic to one of the problematic groups of order 192, 128, 96, and factoring through \rho_{E,2}(G)/\Gamma
