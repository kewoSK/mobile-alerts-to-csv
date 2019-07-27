# mobile-alerts-to-csv

2019-07-27, V0.1, https://github.com/kewoSK

(dumb) macos shell script which consumes data from sensors presented on mobile-alerts.eu web and transforms them to CSV.
If you find it useful, I will be happy. If you have any suggestion for improvement, please, file me an issue.

## Requirements

* macos
* bash
* curl
* grep
* sed

## Configuration
Before using script, please, configure connection details according to following steps. 

1. visit https://measurements.mobile-alerts.eu/
2. enter your _phone ID_ (from _Mobile Alerts_ app) and hit *Show Sensors* button
3. get _DEVICE_ ("MAC" format; _deviceid_ variable), _VENDOR_ (GUID format; _vendorid_ variable) and _APPBUNDLE_ (app handler; _appbundle_ variable) from hidden fields in page source code for desired sensors
4. modify _mobile-alerts-to-csv-mac.sh_ script by editing variables _DEVICE_, _VENDOR_, _APPBUNDLE_ and _INTERVAL_ in _CONFIG SECTION_ according to your needs
5. add execute privilege to the script (`$ chmod u+x mobile-alerts-to-csv-mac.sh`)

## Usage
After configuration and assigning privileges, run

    $ ./mobile-alerts-to-csv-mac.sh
    
to output CSV to stdout, or

    $ ./mobile-alerts-to-csv-mac.sh > filename.csv

to output results to filename.csv.

## Enjoy
