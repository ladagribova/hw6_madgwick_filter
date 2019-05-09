package org.servalproject.sensorlogger;

import java.io.File;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.util.FloatMath;

public class AccelLogger extends SensorLogger
{
	long previousTime=-1;

	public AccelLogger(Detector detector, Sensor sensor, File logFolder)
	{
		super(detector, sensor, SensorManager.SENSOR_DELAY_UI, "Accelerometer", logFolder);
	}

	@Override
	public void logHeader() {
		log("time;accuracy;x;y;z;magnitude\n");
	}

	public void onSensorChanged(SensorEvent event) {
		float rawMagnitude = FloatMath.sqrt(event.values[0] * event.values[0] + event.values[1] * event.values[1] + event.values[2] * event.values[2]);
		previousTime = event.timestamp;
		log(event.timestamp,
				String.format
						("%d;%.3f;%.3f;%.3f;%.3f\n",
								event.accuracy,
								event.values[0],
								event.values[1],
								event.values[2],
								rawMagnitude
						)
		);
	}
}