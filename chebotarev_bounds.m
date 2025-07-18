

/* These are the 6 columns from Bach-Sorenson Table 3. Each tuple is of the form (a,b,c,dstart,dend) and valid for dstart <= |d_K| <= dend and the n_K of the column. */

Infty:=10^100;

case1 := [[3.29,1.48,4.9,1,5], [2.662,0.75,4.8,5,10], [2.301,0.52,5,10,25], [1.881,0.34,5.5,25,100], [1.446,0.23,6.8,100,1000], [1.125,0.63,10.9,1000,10000], [1.032,0.44,20.2,10000,100000], [1.008,-0.06,47.7,100000,Infty]];

case2 := [[2.808,0.58,4.7,5,10], [2.524,0.45,4.9,10,25], [2.035,0.27,5.3,25,100], [1.527,0.17,6.4,100,1000], [1.148,0.5,10.2,1000,10000], [1.038,0.5,18.7,10000,100000], [1.01,-0.03,41.9,100000,Infty]];

case3 := [[2.736,0.35,4.7,10,25], [2.231,0.21,5.1,25,100], [1.629,0.11,6.1,100,1000], [1.178,0.37,9.5,1000,10000], [1.046,0.56,17.3,10000,100000], [1.012,0,37.8,100000,Infty]];

case4 := [[2.303,0.19,4.8,10,25], [2.297,0.19,5,25,100], [1.667,0.09,6,100,1000], [1.189,0.32,9.2,1000,10000], [1.049,0.59,16.8,10000,100000], [1.012,0,37.8,100000,Infty]];

case5 := [[2.228,0.1,4.9,25,100], [1.745,0.04,5.8,100,1000], [1.212,0.24,8.8,1000,10000], [1.054,0.63,16,10000,100000], [1.014,0.02,35.9,100000,Infty]];

case6 := [[1.755,0,5.7,100,1000], [1.257,0,7.3,1000,10000], [1.095,0,8.2,10000,100000], [1.017,0.07,31.8,100000,Infty]];




procedure verify_case(nStart, nEnd, pivoti); 
  if nStart eq 2 and nEnd le 2 then 
	casen:=case1;
  elif nStart eq 3 and nEnd le 4 then
	casen:=case2;
  elif nStart eq 5 and nEnd le 9 then
	casen:=case3;
  elif nStart eq 10 and nEnd le 14 then
	casen:=case4;
  elif nStart eq 15 and nEnd le 49 then
	casen:=case5;
  elif nStart eq 50 then
	casen:=case6;
  end if;

  p0:=-1;

  /* Get a,b,c from the pivot triple */
  a:= casen[pivoti][1];
  b:= casen[pivoti][2];
  c:= casen[pivoti][3];


  /* For each n, compute the special constant p0 and verify the pivot triple is larger than all triples after it. */
  for n in [nStart..nEnd] do
    /* Initialize p_0 using the generic constants a:= 4, b:= 2.5, c:= 5. This takes care of any possible gap in Table 2.1 (see Remark 13 in Mayle-Wang) */
    p0:=Maximum(p0,(4*casen[1][4] + n*2.5 + 5)^2);

    /* Compute the special constant p0(n). */
    for i in [1 .. pivoti-1] do
      p1:=(casen[i][1]*casen[i][5] + casen[i][2]*n + casen[i][3])^2;
      p0:= Maximum(p0,p1);
    end for;

    /* Check that the generic bound dominates the pivot triple and special constant p0(n). */
    n0:=Maximum(72,n);
    p2:=(a*((n0-1)*Log(2)+n0*Log(n0))+b*n0+c)^2;
    assert p0 le p2;

    /* Verify that the triples appearing after the pivot are smaller than the pivot */
    for i in [pivoti+1 .. #casen] do
      aTilde:= casen[i][1];
      bTilde:= casen[i][2];
      cTilde:= casen[i][3];

      /* r is the value such that log |d_K| >= r for the given inequality to hold */
      r:= ((cTilde+bTilde*n)-(c+b*n))/(a-aTilde);

      /* r needs to be <= the lower bound for log |d_K| */
      assert r le casen[i][4];
    end for;

    printf "\n\nResults for n_K = %o: \n\n", n; 
    printf "If log d\_K <= %10.5o, then\n p <= %10.5o \n\n", casen[pivoti][4], p0;
    printf "If log d\_K > %10.5o, then\n p <= (%10.5o \* log d\_K + %10.5o \* n + %10.5o)^2\n\n", casen[pivoti][4], a,b,c;
    printf "The quantity\n\n(%10.5o * ((n0-1) * log(2) + n0 * log(n0)) + %10.5o * n0 + %10.5o)^2\n\ndominates both of the upper bounds where n0 = max(72,n_K)\n\n",a,b,c;
  end for;
end procedure;


verify_case(2, 2, 5);
verify_case(3, 4, 4);
verify_case(5, 9, 3);
verify_case(10, 14, 3);
verify_case(15, 49, 2);
verify_case(50, 128, 1);



/* Compute the final constants for a given triple a,b,c */
procedure final_bound(a,b,c,n);
  printf "Using a,b,c = %o %o %o\n\n", a, b, c, n;
  printf "We obtain a bound of \n\n %10.5o log rad(2 N_E N_E') + %10.5o\n\n", a*(2*n-1), a*2*n*Log(2*n) + b*2*n + c;
end procedure;


final_bound(1.745,0.23,6.8,36);

final_bound(1.745,0.23,6.8,48);

final_bound(1.745,0.23,6.8,24);

final_bound(1.755,0.23,6.8,64);


