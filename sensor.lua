tgtHost = "198.41.30.241"	-- target host (broker)
tgtPort = 1883			-- target port (broker listening on)
id = "c137"
mqttTimeOut = 120		-- connection timeout
dataInt = 1			-- data transmission interval in seconds
topicQueue = "/test/"..id	-- the MQTT topic queue to use
connected = false

function publish_event()
	if (connected) then
		mqttBroker:publish(topicQueue, "d474", 0, 0)
	else
		print("OFFLINE not publishing data")
	end
end

function reconn()
	print("Disconnected, reconnecting....")
	connected = false
	conn()
end

function conn()
	print("Connecting to MQTT broker")
	mqttBroker:connect(tgtHost, tgtPort, 0, connected_cb, failed_cb)
end

function failed_cb(client, reason)
	print("ERROR: "..reason)
	connected = false
end

function connected_cb(...)
	print ("CONNECTED!")
	connected = true
end

-- makeConn() instantiates the MQTT control object, sets up callbacks,
-- connects to the broker, and then uses the timer to send sensor data.
function makeConn()
	print("Instantiating mqttBroker")
	mqttBroker = mqtt.Client(id, mqttTimeOut)
	mqttBroker:on("connect", connected_cb)
	mqttBroker:on("offline", reconn)
	conn()
	tmr.alarm(0, (dataInt * 1000), tmr.ALARM_AUTO, publish_event)
end
