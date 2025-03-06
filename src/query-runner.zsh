#!/bin/zsh -i

cpath=$(<../assets/cvcPath.txt)
query=$(<../assets/queryPath.txt)

while [[ true ]]; do

    if [[ -e "$cpath/cvc5" && -f "$cpath/cvc5" ]]; then
        echo "\033[32m\n-- cvc5 executable located --\033[0m"
        echo $cpath > ../assets/cvcPath.txt
        break
    else
        echo "\n\033[31m-- cvc5 executable not found --\033[0m"
        echo "Please specify the full path to your cv5 executable."
        echo -n "\033[2mFrom Root: \033[0m/"
        read cpath
        cpath=$(echo "/$cpath" | xargs)
    fi
done

yn=""
if [[ -e $query ]]; then
    echo "Would you like to specify a new path to your query folder?"
    echo -n "\033[34m(y/n): \033[0m"
    read yn
    yn=$(echo $yn | xargs)
fi

while [[ $yn == "y" || $yn == "Y" || ! -e $query ]]; do
    
    echo "\nPlease specify the full path to your query folder."
    echo -n "\033[34mFrom Root: \033[0m/"
    read query
    query=$(echo "/$query" | xargs)

    if [[ -e $query ]]; then
        echo "-- Query Folder Located --"
        echo $query > ../assets/queryPath.txt
        break
    else
        echo "-- Query Folder Not Found --"
    fi
done

echo "\nPlease specify a timeout period"
while [[ ! "$yn" =~ ^-?[0-9]+$ ]]; do
    echo -n "\033[32mPeriod (ms): \033[0m"
    read yn
    if [[ ! "$yn" =~ ^-?[0-9]+$ ]]; then
        echo "Not a valid timeout period. Please try again."
    fi
done 

echo "\nProgram Initialized with Settings:"
echo -n "CVC5 Path: "
echo "\033[31m$cpath\033[0m"

echo -n "Query Path: "
echo "\033[34m$query\033[0m"

echo -n "Timeout period: "
echo -n "\033[32m$yn\033[0m"
echo " ms"

smtCount=$(echo $query/*.smt2 | wc -w)
smtCount=$(echo $smtCount | xargs)
echo "\nRunning solver on \033[35m$smtCount\033[0m queries."

sleep 1

sat=0
unsat=0

echo "Query,Result,Time(ms)" > ../assets/results.csv

for file in $query/*.smt2; do
    echo -n "\nRunning "
    echo "\033[36m${file:t}\033[0m"

    bt=$(expr $(expr $(strftime $epochtime[1]) \* 1000000000) + $(strftime $epochtime[2]))

    echo -n "\033[2m"
    output=$($cpath/cvc5 --tlimit=$yn $file)
    echo -n "\033[0m"

    et=$(expr $(expr $(strftime $epochtime[1]) \* 1000000000) + $(strftime $epochtime[2]))

    
    elapsed=$(expr $(expr $et - $bt) / 1000000)

    if [[ ! -z $output ]]; then
        if [[ $output == "sat" ]]; then
            echo "\033[32m$output\t\033[0m($elapsed ms)"
            ((sat++))
        else
            echo "\033[31m$output\t\033[0m($elapsed ms)"
            ((unsat++))
        fi
    else
        output=timeout
    fi
    echo "${file:t},$output,$elapsed" >> ../assets/results.csv
done

(( timed = smtCount - sat - unsat))

echo "\nResults: \033[2m(Saved to ../assets/results.csv)\033[0m"
echo "sat: \033[32m$sat\033[0m"
echo "unsat: \033[31m$unsat\033[0m"
echo "timeout: \033[33m$timed\033[0m"
