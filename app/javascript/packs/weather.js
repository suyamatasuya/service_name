let warningMessage = "";

document.addEventListener("turbolinks:load", function() {
    getLocation();
});

function getGoogleAPIKey() {
    return fetch("/weather/google_api_key")
        .then(response => response.json())
        .then(data => data.google_api_key);
}

function getCityName(lat, lon) {
    return getGoogleAPIKey().then(apiKey => {
        return fetch(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lon}&key=${apiKey}&language=ja`)
            .then(response => response.json())
            .then(data => {
                if (data.status === 'OK') {
                    const results = data.results;
                    return results[0].address_components.find(comp => comp.types.includes('locality')).long_name;
                } else {
                    console.error("Error fetching city name:", data.status);
                    return null;
                }
            })
            .catch(error => {
                console.error("Error fetching city name:", error);
            });
    });
}

const adviceList = [
    "首や腰を冷やさないようにしましょう。",
    "ストレッチを日常的に取り入れると良いです。",
    "適度な運動は首や腰の健康に役立ちます。",
    "長時間の同じ姿勢は避け、定期的に体を動かすことを心がけましょう。",
    "良い姿勢を保つことで、首や腰への負担を減らすことができます。",
    "適切な枕やマットレスを選ぶことで、良い睡眠をサポートします。",
    "日常の動作で腰を曲げるときは、膝を曲げることを意識しましょう。",
    "重いものを持ち上げるときは、腰ではなく膝を使うようにしましょう。",
    "適切な体重を維持することで、首や腰への負担を減らすことができます。",
    "水分をしっかりとることで、筋肉や関節の健康をサポートします。"
];

function getDailyAdvice() {
    const today = new Date();
    const index = today.getDate() % adviceList.length;
    return adviceList[index];
}

function fetchWeatherData(lat, lon) {
    const timezone = "Asia/Tokyo";
    let previousPressure = null;

    fetch(`https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&timezone=${timezone}&daily=temperature_2m_min,temperature_2m_max,weathercode&hourly=pressure_msl`)
        .then(response => response.json())
        .then(data => {
            if (data && data.daily && data.daily.time) {
                const weatherDataElement = document.getElementById('weatherData');
                const timeData = data.daily.time;
                const tempMinData = data.daily.temperature_2m_min;
                const tempMaxData = data.daily.temperature_2m_max;
                const pressureData = data.hourly.pressure_msl;

                for (let i = 0; i < timeData.length; i++) {
                    const tr = document.createElement('tr');

                    const dateCell = document.createElement('td');
                    const date = new Date(timeData[i]);
                    dateCell.textContent = date.toLocaleDateString();
                    tr.appendChild(dateCell);

                    // 天気のマークを表示する部分は削除

                    const tempMinCell = document.createElement('td');
                    tempMinCell.textContent = tempMinData[i] + '℃';
                    tr.appendChild(tempMinCell);

                    const tempMaxCell = document.createElement('td');
                    tempMaxCell.textContent = tempMaxData[i] + '℃';
                    tr.appendChild(tempMaxCell);

                    const pressureCell = document.createElement('td');
                    pressureCell.textContent = pressureData[i] + ' hPa';
                    tr.appendChild(pressureCell);

                    if ((previousPressure !== null && (previousPressure - pressureData[i]) >= 5) || pressureData[i] <= 1000) {
                        warningMessage = "注意: ";
                        if (previousPressure !== null && (previousPressure - pressureData[i]) >= 5) {
                            warningMessage += "昨日と比べて気圧が5hPa以上下がっています。";
                        }
                        if (pressureData[i] <= 1000) {
                            warningMessage += "気圧が1000hPaを切っています。";
                        }
                        warningMessage += "首や腰の痛みを感じる可能性があります。";
                    }

                    previousPressure = pressureData[i];
                    weatherDataElement.appendChild(tr);
                }

                const adviceElement = document.querySelector('.advice-box p');
                if (warningMessage) {
                    const warningElement = document.createElement('p');
                    warningElement.style.color = "red";
                    warningElement.textContent = warningMessage;
                    adviceElement.insertAdjacentElement('beforebegin', warningElement);
                }
                adviceElement.textContent = getDailyAdvice();
            }
        })
        .catch(error => {
            console.error("Error fetching weather data:", error);
        });
}

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}

function showPosition(position) {
    const lat = position.coords.latitude;
    const lon = position.coords.longitude;

    getCityName(lat, lon).then(cityName => {
        if(cityName) {
            document.getElementById("locationTitle").textContent = `${cityName}の1週間の予報`;
            fetchWeatherData(lat, lon);
        }
    });
}

function showError(error) {
    let defaultLat = 35.6895; // 東京の緯度
    let defaultLon = 139.6917; // 東京の経度
    let defaultCityName = "東京";

    switch (error.code) {
        case error.PERMISSION_DENIED:
            console.warn("User denied the request for Geolocation. Displaying weather data for the default location.");
            break;
        case error.POSITION_UNAVAILABLE:
            console.warn("Location information is unavailable. Displaying weather data for the default location.");
            break;
        case error.TIMEOUT:
            console.warn("The request to get user location timed out. Displaying weather data for the default location.");
            break;
        case error.UNKNOWN_ERROR:
            console.warn("An unknown error occurred. Displaying weather data for the default location.");
            break;
    }

    // エラーが発生した場合、デフォルトの地域（東京）の天気情報を表示
    document.getElementById("locationTitle").textContent = `${defaultCityName}の1週間の予報`;
    fetchWeatherData(defaultLat, defaultLon);
}
