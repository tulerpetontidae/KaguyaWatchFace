using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.WatchUi as WatchUi;
using Toybox.ActivityMonitor as ActivityMonitor;

class KaguyaWatchFaceView extends WatchUi.WatchFace {

    var specialNumberFont = null;
    var hourFont = null;
    var minuteFont = null;
    var backgroundImage = null;


    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        specialNumberFont = WatchUi.loadResource(Rez.Fonts.SpecialNumbersFont);
        hourFont = WatchUi.loadResource(Rez.Fonts.HourFont);
        minuteFont = WatchUi.loadResource(Rez.Fonts.MinuteFont);

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
        var xPositionHour = screenHeight / (416.0/114.0);
        
        var xPositionMinute = screenHeight / (416.0/135.0);

        var clockTime = Sys.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour.format("%02d")]);
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPositionHour, yPosition, hourFont, hourString, Gfx.TEXT_JUSTIFY_RIGHT);

        dc.drawText(xPositionMinute, yPosition, minuteFont, minuteString, Gfx.TEXT_JUSTIFY_LEFT);
    }

    function updateBattery(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var xPosition = screenWidth / (416.0/156.0);
        var yPosition = screenHeight / (416.0/56.0);
        var batteryLevel = Sys.getSystemStats().battery;

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPosition, yPosition, specialNumberFont, batteryLevel.format("%d") + "%", Gfx.TEXT_JUSTIFY_CENTER);
    }

    function updateHeartRate(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var xPosition = screenWidth / (416.0/74.0);
        var yPosition = screenHeight / (416.0/255.0);
        var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
        var mostRecentHeartRate = heartrateIterator.next().heartRate;

        if (mostRecentHeartRate != null) {
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xPosition, yPosition, specialNumberFont, mostRecentHeartRate.format("%d"), Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    function updateFootsteps(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        var xPosition = screenWidth / (416.0/94.0);
        var yPosition = screenHeight / (416.0/295.0);
        var footsteps = ActivityMonitor.getInfo().steps;

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPosition, yPosition, specialNumberFont, footsteps.format("%d"), Gfx.TEXT_JUSTIFY_CENTER);
    }


    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}
