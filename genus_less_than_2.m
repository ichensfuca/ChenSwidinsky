// load Rouse-Zureick-Brown data

load "gl2data.txt";

// count the number of modular curves with genus \le 1

// the case when -I is in the group
count:=0;
for i in [1..#newsublist] do
  if newsublist[i][5] notin [0,1] then
    continue;
  end if;
  count:=count+1;
end for;

print "The number of genus \le 1 groups:",count;

// this count comes from the paper of Rouse-Zureick-Brown, Figure 3
finite_count:=10+25+6+165;

print "The number of modular curves with finitely many rational points", finite_count;

print "The number of genus \le 1 groups minus those with finitely many rational points:", count - finite_count;
