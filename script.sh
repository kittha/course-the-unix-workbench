# how to print list (array)
echo "${array[*]}"

# how to print len(list)
echo "${#array[*]}"
---------





# The Unix Workbench Week 3 Functions Exercises
#!/usr/bin/env bash
# File: test.sh

# how to call other function in bash by using $(command substitution)

# function check is it odd or even.
# receive input $1; if mod 2 = 0 print 1; else print 0
function isiteven {
  if [[ $(($1 % 2)) -eq 0 ]]
  then
    echo 1
  else
    echo 0
  fi
}

# function that count even num.
function nevens {
  local neven=0
  for element in $@
  do
    # if we dont call "isiteven function" we can check by using if element % 2 == 0?
    # if [[ $(($element % 2)) -eq 0 ]]
    # if we call function; calling "isiteven function" by using $(command substitution), if the result is even (true) the function will return 1
    if [[ $(isiteven $element) -eq 1 ]]
    then
      #let neven=neven+1
      let neven+=1
    fi
  done
  echo $neven
}

# calculate odd number percentage (calculate percentage example)
function howodd {
  # nevensbsp = nevens / totaln; noddsbsp = 1-nevensbsp
  # call nevens function follow by essential parameter (input).
  neven=$(nevens $@)
  tot=$#
  echo 1-$neven/$tot | bc -l
}

# function that print fibonacci series
 function fib {
  # input 10 #$1
  # output 0 1 1 2 3 5 8 13 21 34
  a=0
  b=1
  for element in $(eval echo "{0..$1}")
  do
    # print a cursor
    echo $a
    # add value to new sum
    fn=$((a+b))
    # slide a cursor to next position
    a=$b
    # set new sum value to b
    b=$fn
  done
}
----------




# The Unix Workbench Week 3 Writing Programs Exercises
# example script show how to use local variable in for loop.
#!/usr/bin/env bash
# File: test.sh

function range {
  local usr_input=$1
  if [[ $usr_input -lt 0 ]]
  then
    local element
    for element in $(eval echo "{$usr_input..0}")
    do
      echo $element
    done
  else
    local element
    for element in $(eval echo "{0..$usr_input}")
    do
      echo $element
    done
  fi
}
----------





# The Unix Workbench Week 3 Writing Programs Exercises
# find min; find max; find min max function.
#!/usr/bin/env bash
# File: test.sh

function extremes {
  local min=$1
  local max=$2
  local element
  for element in $@
  do
    if [[ $min -gt $max ]]
    then
      local tmp
      tmp=$max
      max=$min
      min=$tmp
    fi
    if [[ $element -gt $max ]]
    then
      max=$element
    elif [[ $element -lt $min ]]
    then
      min=$element
    fi
  done
  echo $min $max
}
----------





# The Unix Workbench Week 4 Bash, Make, Git, and GitHub
# Number guessing game

#!/usr/bin/env bash
# File: guessinggame.sh

<<COMMENT
* A guessing game. The player must guess how many files are in current dir.
* INPUT INTEGER only.
  * check "INPUT" validity
* compare "INPUT" with "number of files in current dir"
* OUTPUT feedback: too high && loop, too low && loop, match && end.
COMMENT

function chkinpval {
  # check INPUT validity function; user should enter INTEGER only.

  # check INPUT; if user want to exit.
  if [[ $response = 'exit' ]] || [[ $response = 'quit' ]] || [[ $response = 'q' ]]
  then
    exit 0
  fi

  # check INPUT; if INTEGER then accepted.
  if [[ $response =~ ^[0-9]+$ ]]
  then
    return $response

  # check INPUT; if not INTEGER then rejected.
  else
    ./guessinggame.sh 2> /dev/null
    echo "Please input integers only."
    usrinp
  fi
}

function guessgame {
  # check number of files in current dir.
  numf=$(find . -maxdepth 1 -type f -printf . | wc -c)

  # compare "num of files in current dir" with "user response".
  diff=$(($numf-$response))

  # if user guessed right then congrat and exit
  if [[ $numf == $response ]]
  then
    echo "Congratulation. You guessed right."
    notendgame=0

  # if user guessed too high then the diff value will be negative;
  # eg.files in dir=1 vs user guessed=2; $diff=(1-2)=-1.
  # $diff will turn to negative ($diff < 0).
  elif [[ $diff -lt 0 ]]
  then
    echo "too high"

  # if user guessed too low then the diff value will be positive;
  # eg.files in dir=1 vs user guessed=0; $diff=(1-0)=1.
  # $diff will turn to positive ($diff > 0).
  elif [[ $diff -gt 0 ]]
  then
    echo "too low"

  else
    exit 0
  fi
}

function usrinp {
  # read INPUT from user.
  echo "How many files in this dir? Let's guess (enter 1-100):"
  read response
  chkinpval
}

function main {
  notendgame=1
  while [[ $notendgame -eq 1 ]]
  do
    usrinp
    guessgame
  done
  exit 0
}

main
