
// initialize small group database
DB:=SmallGroupDatabase();

// check if the group G has an element of order > 3
function check_orders(G);
  orders := Set([Order(g) : g in G]);
  if orders subset {1,2,3} then 
    return false, orders;
  else 
    return true, orders;
  end if;
end function;

// check number of isomorphism classes of groups of each order
assert NumberOfSmallGroups(DB,192) eq 1543;
assert NumberOfSmallGroups(DB,144) eq 197;
assert NumberOfSmallGroups(DB,128) eq 2328;
assert NumberOfSmallGroups(DB,96) eq 231;
assert NumberOfSmallGroups(DB,72) eq 50;
assert NumberOfSmallGroups(DB,64) eq 267;
assert NumberOfSmallGroups(DB,48) eq 52;
assert NumberOfSmallGroups(DB,36) eq 14;
assert NumberOfSmallGroups(DB,32) eq 51;



// list of possible orders for delta(G) or a minimal quotient with an element of order > 3
order_list:={ 1, 2, 3, 4, 6, 8, 9, 12, 16, 18, 24, 32, 36, 48, 64, 72, 96, 128, 144, 192 };

// find the problematic groups of the given order
function confirm(sizegroup,problematic)

ngroups:=NumberOfSmallGroups(DB,sizegroup);
MI:={};
for i in [1..ngroups] do
  if i in problematic then
    continue;
  end if;

  G:=SmallGroup(DB,sizegroup,i);
  normal_list:=NormalSubgroups(G);
  normal_nontrivial:=[N : N in normal_list | Order(N`subgroup) gt 1];

  // make a list of smaller quotients with an element of order > 3
  NI:={};
  for N in normal_nontrivial do
    H:=G/N`subgroup;
    if check_orders(H) then
      NI:=NI join {Order(H)};
    end if;
  end for;
  //print "Group #", i, ": ", NI;

  // check that the smaller quotients still lie in the list of possible orders
  assert Set(NI) subset order_list;

  // record the minimal quotient with an element of order > 3
  MI:=MI join {Minimum(NI)};
end for;

// return the maximum size of a minimal quotient with an element of order > 3
return Maximum(MI);

end function;



// confirm the maximum size of minimal quotients with an element of order > 3
// confirm the stated list of problematic groups

assert confirm(192,[1023,1025,1541]) eq 96;
assert confirm(144,[]) eq 36;
assert confirm(128,[2326,2327,2328]) eq 64;
assert confirm(96,[204]) eq 24;
assert confirm(72,[]) eq 24;
assert confirm(64,[266,267]) eq 32;
assert confirm(48,[3,50]) eq 24;
assert confirm(36,[11]) eq 12;
assert confirm(32,[49,50,51]) eq 16;








