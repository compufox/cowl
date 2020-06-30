all: 
	ros run --eval "(progn (ql:quickload :cowl) (asdf:make :cowl))"

