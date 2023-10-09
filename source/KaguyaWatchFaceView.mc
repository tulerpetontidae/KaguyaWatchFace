using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as WatchUi;
using Toybox.ActivityMonitor as ActivityMonitor;

class KaguyaWatchFaceView extends WatchUi.WatchFace {

    var specialNumberFont = null;
    var backgroundImage = null;


    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        specialNumberFont = WatchUi.loadResource(Rez.Fonts.SpecialNumbersFont);
        backgroundImage = WatchUi.loadResource(Rez.Drawables.BackgroundImage);
        

    }

    function onShow() as Void {
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
        if (backgroundImage != null) {
                dc.drawBitmap(0, 0, backgroundImage);
            } else {
                Sys.println("Background image is null.");
            }
        updateClock(dc);
        updateBattery(dc);
        updateHeartRate(dc);
    }

    function updateClock(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();  // Use getHeight for accuracy
        var xPosition = screenWidth / 16;
        var yPosition = screenHeight / 2.4;       

        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$", [clockTime.hour.format("%02d")]);  // 24-hour format, two digits
        
        var view = View.findDrawableById("TimeLabel") as Toybox.WatchUi.Text;  // Find the drawable by ID
        view.setLocation(xPosition, yPosition);  // Corrected line
        view.setColor(Gfx.COLOR_WHITE);  // Set colour to white
        view.setFont(specialNumberFont);  // Set the font
        view.setText(timeString);  // Update the text
    }



    function updateBattery(dc) {

        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();  // Use getHeight for accuracy
        var xPosition = screenWidth / (416.0/146.0);
        var yPosition = screenHeight / (416.0/76.0);         

        var systemStats = Sys.getSystemStats();
        var batteryLevel = systemStats.battery;
        var batteryView = View.findDrawableById("BatteryLabel") as Toybox.WatchUi.Text;
        batteryView.setFont(specialNumberFont);  // Make sure the font ID matches what you've defined in fonts.xml
        batteryView.setColor(Gfx.COLOR_WHITE);  // Set colour to white
        batteryView.setLocation(xPosition, yPosition);  // Corrected line
        batteryView.setText(batteryLevel.format("%d") + "%");
    }

    function updateHeartRate(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();  // Use getHeight for accuracy
        var xPosition = screenWidth / (416.0/77.0);
        var yPosition = screenHeight / (416.0/273.0); 

        var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
        var mostRecentHeartRate = heartrateIterator.next().heartRate;
        if (mostRecentHeartRate != null) {
            var hrView = View.findDrawableById("HeartRateLabel") as Toybox.WatchUi.Text;
            hrView.setFont(specialNumberFont);  // Make sure the font ID matches what you've defined in fonts.xml
            hrView.setColor(Gfx.COLOR_WHITE);  // Set colour to white
            hrView.setLocation(xPosition, yPosition);  // Corrected line
            hrView.setText(mostRecentHeartRate.format("%d"));
        }
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}
