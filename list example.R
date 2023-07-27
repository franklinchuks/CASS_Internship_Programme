rm(list=ls())

y=0 #initialize variable

for (i in 1:15) #for each object (i) in an array (1:5), do the contained operations, starting from the top
{
  y = y + i
  
  print (i)
}

print (y)
