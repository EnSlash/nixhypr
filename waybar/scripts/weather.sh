#!/bin/sh
# weather.sh

# Get the weather information from wttr.in
weather=$(curl -s "wttr.in?format=j1")

# Check if the request was successful
if [ -z "$weather" ]; then
    echo '{"text": "N/A", "tooltip": "Weather data not available"}'
    exit 1
fi

# Parse the JSON response
condition=$(echo "$weather" | jq -r '.current_condition[0].weatherDesc[0].value')
temp_c=$(echo "$weather" | jq -r '.current_condition[0].temp_C')
feels_like_c=$(echo "$weather" | jq -r '.current_condition[0].FeelsLikeC')
humidity=$(echo "$weather" | jq -r '.current_condition[0].humidity')
wind_speed=$(echo "$weather" | jq -r '.current_condition[0].windspeedKmph')

# Get a simple weather icon
weather_icon=""
case $(echo "$condition" | tr '[:upper:]' '[:lower:]') in
    *sunny*|*clear*) 
        weather_icon="☀️"
        ;;
    *partly*cloudy*) 
        weather_icon="⛅"
        ;;
    *cloudy*) 
        weather_icon="☁️"
        ;;
    *overcast*) 
        weather_icon="🌥️"
        ;;
    *mist*|*fog*) 
        weather_icon="🌫️"
        ;;
    *patchy*rain*|*light*rain*) 
        weather_icon="🌦️"
        ;;
    *rain*|*shower*) 
        weather_icon="🌧️"
        ;;
    *thunder*) 
        weather_icon="⛈️"
        ;;
    *snow*) 
        weather_icon="❄️"
        ;;
    *sleet*) 
        weather_icon="🌨️"
        ;;
    *blizzard*) 
        weather_icon="🌬️"
        ;;
    *)
        weather_icon="?"
        ;;
esac

# Format the output for Waybar
text="$weather_icon $temp_c°C"
tooltip="<b>$condition</b>\nFeels like: $feels_like_c°C\nHumidity: $humidity%\nWind: $wind_speed km/h"

printf '{"text": "%s", "tooltip": "%s"}\n' "$text" "$tooltip"
