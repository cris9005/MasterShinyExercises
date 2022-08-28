## RSHINY 

#Just the basics
objects() or ls() # display objects in current env
rm(object1, object2) # remove object

## Library
library(packageName) or require(packageName) # Load
detach(packageName) # unload package name

##Manipulating strings
# putting together strings
paste('string1','string2', sep = '/') #sep is space
paste(c('1','2', collapse = '/'))


#split string
# returns a list
stringr::str_split(string = v1, pattern = '-')


#get substring
stringr::str_sub(string = v1, start = 1, end = 3)

isJohnfound <- stringr::str_detect(string=df1$col1, pattern = ignore.case('John'))
# Returns True/False if John was found
fd1[isJohnfound,c('col1'), ...]
exit
