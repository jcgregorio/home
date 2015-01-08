all:	temper tempmon

.PHONY: tempmon
tempmon:
	go build -v ./go/tempmon
	sudo install  -D --verbose --backup=none --group=root --owner=root  --mode=755 tempmon /usr/local/bin/tempmon

deps:
	sudo apt-get install libusb-dev


CFLAGS = -O2 -Wall

temper:	temper.c
	${CC} -DUNIT_TEST -o $@ $^ -lusb
	sudo install  -D --verbose --backup=none --group=root --owner=root  --mode=755 temper /usr/local/bin/temper

clean:		
	rm -f temper *.o

rules-install:			# must be superuser to do this
	cp 99-tempsensor.rules /etc/udev/rules.d
	sudo udevadm control --reload-rules
	sudo install -D --verbose --backup=none --group=root --owner=root  --mode=755 tempmon_init /etc/init.d/tempmon
	sudo /etc/init.d/tempmon start
	sudo install -D --verbose --backup=none --group=root --owner=root  --mode=666 tempmon_monit /etc/monit/conf.d/tempmon
	sudo monit reload

