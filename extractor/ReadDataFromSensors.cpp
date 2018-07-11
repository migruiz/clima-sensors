/* ===================================================
C code : test.cpp
* ===================================================
*/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <chrono>
#include <inttypes.h>
#include "RCSwitch.h"
#include "RcOok.h"
#include "Sensor.h"



int main(int argc, char *argv[])
{
	int RXPIN = 1;
	int TXPIN = 0;
        FILE *fp;        // Global var file handle
        

	if(wiringPiSetup() == -1)
		return 0;

	RCSwitch *rc = new RCSwitch(RXPIN,TXPIN);

	while (1)
	{
		if (rc->OokAvailable())
		{
			char message[100];

			rc->getOokCode(message);

			Sensor *s = Sensor::getRightSensor(message);
			if (s!= NULL)
			{

				using namespace std::chrono;
				milliseconds milis = duration_cast< milliseconds >(
					system_clock::now().time_since_epoch()
					);
				char buffer[64]; // The filename buffer.
								 // Put "file" then k then ".txt" in to filename.
				if (argc == 2) {
					snprintf(buffer, sizeof(char) * 64, "%s%" PRId64 ".csv", argv[1], milis);
				}
				else {
					snprintf(buffer, sizeof(char) * 64, "%" PRId64 ".csv", milis);
				}

				fp = fopen(buffer, "w");
				fprintf(fp, "%s,%d,%f,%f\n", message, s->getChannel(), s->getTemperature(), s->getHumidity());
				fflush(fp);
				fflush(stdout);
				fclose(fp);
			}
			delete s;
		}
		delay(1000);
	}


}
