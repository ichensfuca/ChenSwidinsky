
// this program verifies the assertion after (5.14)

// initialize small group database
DB:=SmallGroupDatabase();

// list of problematic groups
G192a:=SmallGroup(DB,192,1023);
G192b:=SmallGroup(DB,192,1025);
G192c:=SmallGroup(DB,192,1541);
G128a:=SmallGroup(DB,128,2326);
G128b:=SmallGroup(DB,128,2327);
G128c:=SmallGroup(DB,128,2328);
G96a:=SmallGroup(DB,96,204);
G64a:=SmallGroup(DB,64,266);
G64b:=SmallGroup(DB,64,267);
G48a:=SmallGroup(DB,48,3);
G48b:=SmallGroup(DB,48,50);
G36a:=SmallGroup(DB,36,11);
G32a:=SmallGroup(DB,32,49);
G32b:=SmallGroup(DB,32,50);
G32c:=SmallGroup(DB,32,51);

problematic_groups:=[G192a,G192b,G192c,G128a,G128b,G128c,G96a,G64a,G64b,G48a,G48b,G36a,G32a,G32b,G32c];


// the commands below are used to create the semidirect product
F:=ResidueClassRing(2);
R:=MatrixAlgebra(F,2);
H:=GeneralLinearGroup(2,F);

// abstract description of the abelian group of two by two matrices in F with trace zero
K:=AbelianGroup<a,b,c,d | 2*a, 2*b, 2*c, 2*d, a - d>;

// given an element in the group K, find the matrix representation
function to_matrix(k)
for ai, bi, ci in [0..1] do
   k0:=ai*K.1 + bi*K.2 + ci*K.3;
   if k eq k0 then 
      return R![ai,bi,ci,ai];
   end if;
end for;
end function;

// given a matrix representation, find the element in the group K
function to_group(m);
ai:=Integers()!m[1,1];
bi:=Integers()!m[1,2];
ci:=Integers()!m[2,1];
di:=Integers()!m[2,2];

assert 2*(ai-di) eq 0;

return ai*K.1 + bi*K.2 + ci*K.3;
end function;

// create the homomorphism from H to Aut(K)
A:=AutomorphismGroup(K);
AI:=[];
for g in SetToSequence(Generators(H)) do
  KI:=[];
  for k in SetToSequence(Generators(K)) do
    k2:=to_group(g*to_matrix(k)*g^(-1));
    KI:=Append(KI,<k,k2>);
  end for;
  a:=A!hom<K -> K | KI>;
  AI:=Append(AI,<g,a>);
end for;
phi:=hom<H -> A | AI>;

// create the semidirect product
G,i1,i2,p2:=SemidirectProduct(K,H,phi);

// list of subgroups of the semidirect product
S_list:=Subgroups(G);

// the list of possible orders of subgroups of the semidirect product
assert {#G`subgroup : G in S_list} eq {1,2,3,4,6,8,12,16,24,48};

// list of subgroups of order 24, 16 in the semidirect product
sub24:=[S`subgroup : S in S_list | #S`subgroup eq 24];
sub16:=[S`subgroup : S in S_list | #S`subgroup eq 16];

// check that if a problematic group has a quotient isomorphic to the group H
function check_groups(H);
  normal_pass:=[];
  for G in problematic_groups do
    normal_list:=[N : N in NormalSubgroups(G) | Order(G/N`subgroup) eq #H];
    normal_pass:=normal_pass cat [N : N in normal_list | IsIsomorphic(G/N`subgroup,H)];
  end for;

  return normal_pass eq [];
end function;

// check subgroups of order 48, 24, 16 in the semidirect product cannot be quotients of the problematic groups
assert check_groups(G);
assert check_groups(sub24[1]);
assert check_groups(sub24[2]);
assert check_groups(sub24[3]);
assert check_groups(sub16[1]);








