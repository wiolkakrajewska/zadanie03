-- Wioleta Paw�owska
-- zadanie03

-- a. Jaka by�a i w jakim kraju mia�a miejsce najwy�sza dzienna amplituda temperatury? (25%)

select wslt."NAME" 
    , max(maxtemp-mintemp) as max_amplitude
from summary_of_weather_txt sowt
join weather_station_locations_txt wslt on sowt.sta = wslt.wban 
group by wslt."NAME"

--b. Z czym silniej skorelowana jest �rednia dzienna temperatura dla stacji � 
-- szeroko�ci� (lattitude) czy d�ugo�ci� (longtitude) geograficzn�? (25%)

select corr(sowt.meantemp, wslt.latitude) as korelacja_szerokosc
    , corr(sowt.meantemp, wslt.longitude) as korelacja_dlugosc
from summary_of_weather_txt sowt 
join weather_station_locations_txt wslt on wslt.wban = sowt.sta;


--c) Poka� obserwacje, w kt�rych suma opad�w atmosferycznych (precipitation) przekroczy�a 
-- sum� opad�w z ostatnich 5 obserwacji na danej stacji. (25%)

select precip 
    , "Date"
    , wslt."NAME" 
from summary_of_weather_txt sowt 
join weather_station_locations_txt wslt on wslt.wban = sowt.sta 




-- d) Uszereguj stany/pa�stwa wed�ug od najni�szej temperatury zanotowanej tam w okresie 
-- obserwacji u�ywaj�c do tego funkcji okna (25%)

select dense_rank() over(order by min(sowt.mintemp)) as ranking
    , wslt."STATE/COUNTRY ID" 
    , min(sowt.mintemp) 
from summary_of_weather_txt sowt
join weather_station_locations_txt wslt  on sowt.sta = wslt.wban 
group by "STATE/COUNTRY ID"
order by min(sowt.mintemp) asc;


-- e) BONUS: czy gdzie� mogli�my do�wiadczy� lipcowych opad�w �niegu? (niespodzianka)

select wslt."STATE/COUNTRY ID" 
    , extract(month from "Date") as july
    , sum(sowt.snowfall) over(partition by wslt."STATE/COUNTRY ID" order by extract(month from "Date")) as �nieg
from summary_of_weather_txt sowt
join weather_station_locations_txt wslt on sowt.sta = wslt.wban 
group by sowt.snowfall, extract(month from "Date"), wslt."STATE/COUNTRY ID" 
having extract(month from "Date") = 7;

-- odpowied�: Nigdzie nie do�wiadczono opad�w �niegu w lipcu.
		
