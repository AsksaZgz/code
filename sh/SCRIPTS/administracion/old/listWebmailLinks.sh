find . -name inbox -exec ls -la {} \; | gawk '{
  split($9, arrA, /[/]/);
  inbox = arrA[2];
  
  split($11, arrB, /[/]/);
  max = 0;
  for (var in arrB)
  {
    if (var > max)
      max = var;
  }
  
  point = arrB[max]; 
  
  print "inbox: " inbox ", \t\t\tpoint: " point;
}'
