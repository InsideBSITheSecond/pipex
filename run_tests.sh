#!/bin/bash

CMD1="ls -l"
CMD2="wc -l"

IN1="infile"
OUT1="outfile1"

IN2="infile"
OUT2="outfile2"

perform_test() {
    local bash_command=`< $IN1 $CMD1 | $CMD2 > $OUT1`
	local pipe_command=`./pipex $IN2 "$CMD1" "$CMD2" $OUT2`

	echo $bash_command
	echo $pipe_command

	diff $OUT1 $OUT2
}

perform_test
