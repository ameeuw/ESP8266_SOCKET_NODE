-- init.lua module
-- Author: Arne Meeuw
-- github.com/ameeuw
--
-- This skript is launched after boot of ESP8266 and loads the Wifi configuration (expected in wifi.lua).
-- If this fails, enduser_setup is launched and the settings are saved.
-- After an IP is acquired, begin() is triggered.

-- Declare global name concatenated from purpose-name and MAC address
name = 'Sonoff:'..string.sub(wifi.sta.getmac(),13,-1)

-- Initialize global PWM RGBled on pins 8,6,7 (floodlight on 6,5,7)
-- if ( file.exists("RGBled.lua") or file.exists("RGBled.lc") ) then
-- 	RGBled = require("RGBled").new("PWM",{8,6,7})
-- end
-- Initialize global Button on pin 2
-- if ( file.exists("Button.lua") or file.exists("Button.lc") ) then
--Button = require("Button").new(2,function() print("Short press.") end,telnet)
-- end

-- IP acquired, begin()
function begin()
		print(name.." is starting.")
    Sonoff = require("Sonoff").new(name, nil, nil)
end

-- Check for IP status
function checkIP()
		if RGBled ~= nil then
    	RGBled:breathe(-1,100,138,11)
		end
    tmr.alarm(4,2000, 1,
      function()
        if wifi.sta.getip()==nil then
            print("Waiting for IP address...")
        else
            print("Obtained IP: "..wifi.sta.getip())
						if RGBled ~= nil then
            	RGBled:breathe(3,150,52,141,0)
						end
            begin()
            tmr.stop(4)
        end
      end)
end

-- Write wifi station config to wifi.lua
function writeSettings()
    local ssid, password, _, _ = wifi.sta.getconfig()
    file.remove("wifi.lua")
    file.open("wifi.lua", "a+")
    file.writeline('wifi.setmode(wifi.STATION)')
    file.writeline('wifi.sta.config("'..ssid..'","'..password..'")')
		file.writeline('wifi.sta.autoconnect(1)')
    file.close()
end

-- Try to open wifi.lua and start enduser_setup if it fails
if file.exists('wifi.lua') then
    dofile('wifi.lua')
    checkIP()
else
    if enduser_setup~=nil then
				if RGBled ~= nil then
        	RGBled:breathe(-1,0,255,11)
				end
				if name == nil then
	        name = 'Sonoff:'..string.sub(wifi.sta.getmac(),13,-1)
				end
        wifi.setmode(wifi.STATIONAP)
        wifi.ap.config({ssid=name, auth=wifi.AUTH_OPEN})
        enduser_setup.manual(true)
        print('Starting end user setup..')
        enduser_setup.start(
          function()
              print("Connected to wifi as:" .. wifi.sta.getip())
              writeSettings()
              checkIP()
          end,

          function(err, str)
              print("enduser_setup: Err #" .. err .. ": " .. str)
          end)
    end
end

-- Start telnet to update code
function telnet()
			print("Starting telnet remote.")
			--dofile("telnet.lc")
end
