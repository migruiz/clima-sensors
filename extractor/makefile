CXXFLAGS += -O2 -Wall -g -pthread -std=c++11

all: ReadDataFromSensors

ReadDataFromSensors: RCSwitch.o RcOok.o Sensor.o ReadDataFromSensors.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $+ -o $@ -lwiringPi -lwiringPiDev -lpthread -lm -lcrypt -lrt

clean:
	$(RM) *.o ReadDataFromSensors
