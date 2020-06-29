all: clean
	ros run --eval "(progn (ql:quickload :cowl) (asdf:make :cowl))"
	cp -r resources/ bin/

clean:
	rm -fr bin/resources
