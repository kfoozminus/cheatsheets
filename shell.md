```
#!/bin/bash
```

A file contains a word per line. Replace each word by its original form and its uppercase. Example: replace `auto` by `auto {return AUTO ;}`
(For `awk` $0 = whole line, $1 = first field, $2 = 2nd field ... $n = nth field)
```
while read p; do
	echo "$p {return $p ;}" | awk '{$3 = touppper($3); print $0}'
done < in > out
```



Replace every ' ' by '\n'
```
tr ' ' '\n' < in > out
```

Replace a word by its uppercase
```
tr '[a-z]' '[A-Z]'
```

Sort strings in a file
```
sort < in > out
```

Cut - remove sections from each line of file
```
cut -f 2- -d ":"
```
-d = delimiter
divides the line in fields by ":", then removes until 2nd field
