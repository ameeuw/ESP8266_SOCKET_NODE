-- Sonooff.lua module
-- Author: Arne Meeuw
-- github.com/ameeuw
--
-- Module for ITEAD Sonoff hardware
--
-- Initialize:
-- Sonoff = require('Sonoff').new()
--

local Sonoff = {}
Sonoff.__index = Sonoff

function Sonoff.new(name, pressCallback, longPressCallback)
	-- TODO: add timer variable to change timer number
	local self = setmetatable({}, Sonoff)
	local relayPin = 6
	local buttonPin = 3
	local ledPin = 7

	if name == nil then
		name = 'Sonoff:'..string.sub(wifi.sta.getmac(),13,-1)
	end

	-- Instantiate new MQTT client
	if MqttClient == nil and ( file.exists("MqttClient.lua") or file.exists("MqttClient.lc") ) then
			MqttClient = require("MqttClient").new("m-e-e-u-w.de", 62763)
	end

	if MqttClient ~= nil then
	-- add hooks
	MqttClient:register("on/set",
		function(topic, message)
			if message == "true" then
				self.Socket:set(true)
			else
				self.Socket:set(false)
			end
			MqttClient.MqttClient:publish(MqttClient.topic..'on/get',tostring(self.Socket.state), 0, 1)
		end)
	end

	-- Button to SonOff
	self.Button = require("Button").new(buttonPin, function() self.buttonPress(self) end, function() self.buttonLongPress(self) end)

	-- Add switchable Socket to Sonoff
	self.Socket = require("Socket").new(relayPin)

	-- Add button callbacks to Sonoff
	if pressCallback~=nil then
		self.pressCallback = pressCallback
	else
		self.pressCallback = function() print("Short press!") end
	end

	if longPressCallback~=nil then
		self.longPressCallback = longPressCallback
	else
		self.longPressCallback = function() print("Long press!") end
	end

	return self
end

function Sonoff.buttonPress(self)
	self.pressCallback()
	self.Socket:toggle()
	if MqttClient ~= nil then
		MqttClient.MqttClient:publish(MqttClient.topic.."on/get", tostring(self.Socket.state), 0, 1)
	end
end

function Sonoff.buttonLongPress(self)
	self.longPressCallback()
end

return Sonoff
