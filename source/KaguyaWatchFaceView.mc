using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as WatchUi;
using Toybox.ActivityMonitor as ActivityMonitor;

class KaguyaWatchFaceView extends WatchUi.WatchFace {

    var specialNumberFont = null;
    var hourFont = null;
    var minuteFont = null;
    var textFont = null;
    var iconFont = null;
    var backgroundImage = null;
    var batteryWidth = null;


    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        specialNumberFont = WatchUi.loadResource(Rez.Fonts.SpecialNumbersFont);
        hourFont = WatchUi.loadResource(Rez.Fonts.HourFont);
        minuteFont = WatchUi.loadResource(Rez.Fonts.MinuteFont);
        textFont = WatchUi.loadResource(Rez.Fonts.TextFont);
        iconFont = WatchUi.loadResource(Rez.Fonts.IconFont);

        backgroundImage = WatchUi.loadResource(Rez.Drawables.BackgroundImage);

        batteryWidth = WatchUi.loadResource(Rez.Strings.BatteryWidth).toFloat();
    }

    function onShow() as Void {
    }

    function onUpdate(dc) {
        if (backgroundImage != null) {
            dc.drawBitmap(0, 0, backgroundImage);
        } else {
            Sys.println("Background image is null.");
        }

        updateClock(dc);
        updateBattery(dc);
        updateHeartRate(dc);
        updateFootsteps(dc);
    }

    function updateClock(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        
        var yPosition = screenWidth / (416.0/115.0);
        var xPositionHour = screenHeight / (416.0/(114.0-10.0));
        
        var xPositionMinute = screenHeight / (416.0/(135.0-10.0));

        var yPositionDay = screenWidth / (416.0/(183.0+15.0));
        var xPositionDay = screenHeight / (416.0/(125.0-10.0));

        var clockTime = Sys.getClockTime();
        var currentTime = Toybox.Time.Gregorian.info(Toybox.Time.now(), Toybox.Time.FORMAT_MEDIUM);  // Converting to Gregorian date-time information
        var day = currentTime.day;
        var month = currentTime.month;
        var year = currentTime.year % 100;  // Get last two digits of year

        var hourString = Lang.format("$1$", [clockTime.hour.format("%02d")]);
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        var dateString = Lang.format("$1$ $2$ $3$", [
            day.format("%02d"), 
            Lang.format("$1$", [month]).substring(0, 3), 
            year.format("%02d")
        ]);


        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPositionHour, yPosition, hourFont, hourString, Gfx.TEXT_JUSTIFY_RIGHT);

        dc.drawText(xPositionMinute, yPosition, minuteFont, minuteString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(xPositionDay, yPositionDay, textFont, dateString, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function updateBattery(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var xPosition = screenWidth / (416.0/209.0);
        var yPosition = screenHeight / (416.0/12.0);

        var xPosition_battery = xPosition - 45 * screenWidth / 416.0;
        var yPosition_battery = yPosition - 3 * screenWidth / 416.0;

        var batteryLevel = Sys.getSystemStats().battery;

        // Determine dimensions for battery icon
        // var batteryWidth = 25 * screenWidth / 416.0;
        var batteryHeight = 43 * screenWidth / 416.0;
        
        // Draw filled rectangle to represent the full battery icon
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.fillRectangle(xPosition_battery + 1, yPosition_battery + 1, batteryWidth-1, batteryHeight-1);
        
        // Calculate the filled part based on battery level
        var fillWidth = (batteryLevel / 100.0) * batteryWidth;
        
        // Draw filled rectangle to represent the current battery level
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        dc.fillRectangle(xPosition_battery + 1, yPosition_battery + 1, fillWidth-1, batteryHeight-1);
        
        // Create and draw the clipping mask for battery icon
        dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
        // dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPosition_battery, yPosition_battery, iconFont, "h", Gfx.TEXT_JUSTIFY_LEFT);

        // Draw the battery percentage next to the icon
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPosition_battery, yPosition_battery, iconFont, "k", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(xPosition, yPosition, specialNumberFont, batteryLevel.format("%d") + "%", Gfx.TEXT_JUSTIFY_LEFT);
    }


    function updateHeartRate(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var xPosition = screenWidth / (416.0/(79.0 - 15.0));
        var yPosition = screenHeight / (416.0/250.0);
        var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
        var mostRecentHeartRate = heartrateIterator.next().heartRate;

        if (mostRecentHeartRate != null) {
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xPosition - 45 * screenWidth / 416.0, yPosition - 5.0, iconFont, "p", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(xPosition, yPosition, specialNumberFont, mostRecentHeartRate.format("%d"), Gfx.TEXT_JUSTIFY_LEFT);
        }
    }

    function updateFootsteps(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var xPosition = screenWidth / (416.0/(99.0 - 15.0));
        var yPosition = screenHeight / (416.0/296.0);
        var footsteps = ActivityMonitor.getInfo().steps;
        var footstepsInThousands = (footsteps / 1000.0).format("%.1f");

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPosition - 35 * screenWidth / 416.0, yPosition, iconFont, "s", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(xPosition, yPosition, specialNumberFont, footstepsInThousands + "k", Gfx.TEXT_JUSTIFY_LEFT);
    }


    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}
