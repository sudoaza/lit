SSID    = "Compartir!"
APPWD   = "Compartir!"

wifi_tries   = 0     -- Counter of trys to connect to wifi
MAX_WIFI_TRIES  = 30    -- Maximum number of WIFI Testings while waiting for connection

function launch()
  print("IP Address: " .. wifi.sta.getip())
  dofile("sensor.lua")
  makeConn()
end

function schedule_launch()
  tmr.alarm(1, 500, tmr.ALARM_SINGLE, launch )
end

function connected()
  ipAddr = wifi.sta.getip()
  return ((ipAddr ~= nil) and (ipAddr ~= "0.0.0.0"))
end

function check_wifi()
  if ( wifi_tries > MAX_WIFI_TRIES ) then
    print("ERROR: Unable to connect")
  else
    if (connected()) then
      schedule_launch()
    else
      schedule_check_wifi()
      wifi_tries = wifi_tries + 1
    end
  end
end

function schedule_check_wifi()
  tmr.alarm(0, 2500, tmr.ALARM_SINGLE, check_wifi)
  print("Checking WIFI... " .. wifi_tries)
end

function config_wifi()
  print("Configuring WIFI....")
  wifi.setmode( wifi.STATION )
  wifi.sta.config(SSID , APPWD)
end

-- 5 sec to allow us to ovewrite scripts
tmr.alarm(0, 5000, tmr.ALARM_SINGLE, function()
    print("-- Starting up! ")
    if (not connected()) then
      config_wifi()
      schedule_check_wifi()
    else
      launch()
    end
  end)
