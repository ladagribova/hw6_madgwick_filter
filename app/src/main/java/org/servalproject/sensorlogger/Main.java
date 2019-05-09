package org.servalproject.sensorlogger;

import android.app.Activity;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import java.util.Timer;
import java.util.TimerTask;

public class Main extends Activity implements OnClickListener
{
	TextView tvText;
	SensorManager sensorManager;
	Sensor sensorAccel;
	Sensor sensorGyro;
	Sensor sensorMag;
	StringBuilder sb = new StringBuilder();
	Timer timer;
	Button start;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		this.setContentView(R.layout.main);

		tvText = (TextView) findViewById(R.id.textView);
		sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);

		sensorAccel = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
		sensorGyro = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
		sensorMag = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

		start = (Button) this.findViewById(R.id.start);
		start.setOnClickListener(this);
	}

	@Override
	protected void onResume() {
		super.onResume();
		setText(Detector.running);
		TextView deviceId = (TextView)this.findViewById(R.id.device_id);
		deviceId.setText("Device ID: "+Detector.getId(this));

		sensorManager.registerListener(listener, sensorAccel,
				SensorManager.SENSOR_DELAY_NORMAL);

		sensorManager.registerListener(listener, sensorGyro,
				SensorManager.SENSOR_DELAY_NORMAL);

		sensorManager.registerListener(listener, sensorMag,
				SensorManager.SENSOR_DELAY_NORMAL);

		timer = new Timer();
		TimerTask task = new TimerTask() {
			@Override
			public void run() {
				runOnUiThread(new Runnable() {
					public void run() {
						showInfo();
					}
				});
			}
		};
		timer.schedule(task, 0, 10);

	}

	@Override
	protected void onPause() {
		super.onPause();
		sensorManager.unregisterListener(listener);
		timer.cancel();
	}

	void showInfo() {
		sb.setLength(0);
		sb.append("Accelerometer: " + format(valuesAccel))

				.append("\nGyroscope : " + format(valuesGyro))
				.append("\nMagnetic_Field : " + format(valuesMag));

		tvText.setText(sb);
	}

	float[] valuesAccel = new float[3];
	float[] valuesGyro = new float[3];
	float[] valuesMag = new float[3];

	SensorEventListener listener = new SensorEventListener() {

		public void onAccuracyChanged(Sensor sensor, int accuracy) {
		}

		public void onSensorChanged(SensorEvent event) {
			switch (event.sensor.getType()) {
				case Sensor.TYPE_ACCELEROMETER:
					for (int i = 0; i < 3; i++) {
						valuesAccel[i] = event.values[i];
					}
					break;

				case Sensor.TYPE_GYROSCOPE:
					for (int i = 0; i < 3; i++) {
						valuesGyro[i] = event.values[i];
					}
					break;

				case Sensor.TYPE_MAGNETIC_FIELD:
					for (int i = 0; i < 3; i++) {
						valuesMag[i] = event.values[i];
					}
					break;
			}

		}
	};

	String format(float values[]) {
		return String.format("%1$.1f\t\t%2$.1f\t\t%3$.1f", values[0], values[1], values[2]);
	}

	public void setText(boolean started){
		start.setText(started?"Stop":"Start");
	}
	
	public void onClick(View arg0) {

		Intent serviceIntent = new Intent(this, Detector.class);
		if (Detector.running){
			stopService(serviceIntent);
			setText(false);
		}else{
			startService(serviceIntent);
			setText(true);
		}
	}
}
