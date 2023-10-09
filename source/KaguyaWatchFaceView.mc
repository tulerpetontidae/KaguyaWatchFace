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
        var batteryLevel = Sys.getSystemStats().battery;

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPosition - 40 * screenWidth / 416.0, yPosition - 3.0, iconFont, "h", Gfx.TEXT_JUSTIFY_LEFT);
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
            dc.drawText(xPosition - 40 * screenWidth / 416.0, yPosition + 2.0, iconFont, "p", Gfx.TEXT_JUSTIFY_LEFT);
            dc.drawText(xPosition, yPosition, specialNumberFont, mostRecentHeartRate.format("%d") + "bpm", Gfx.TEXT_JUSTIFY_LEFT);
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
        dc.drawText(xPosition - 40 * screenWidth / 416.0, yPosition, iconFont, "s", Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(xPosition, yPosition, specialNumberFont, footstepsInThousands + "k", Gfx.TEXT_JUSTIFY_LEFT);
    }


    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}
