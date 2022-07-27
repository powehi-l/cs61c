for((i=0; i<9; i=i+1))
do
#	path_in="inputs/mnist/bin/inputs/mnist_input"$i".bin"
	path_out="output/output"$i".bin"
	path_out1="output/output"$i".txt"
	echo "$path_out $path_out1"

#	java -jar venus.jar main.s -it -ms -1 inputs/mnist/bin/m0.bin inputs/mnist/bin/m1.bin ${path_in} ${path_out} 
	python convert.py $path_out $path_out1 --to-ascii
done
