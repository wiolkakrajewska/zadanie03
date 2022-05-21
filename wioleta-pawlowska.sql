-- Wioleta Paw³owska
-- zadanie03

-- a. Jaka by³a i w jakim kraju mia³a miejsce najwy¿sza dzienna amplituda temperatury? (25%)

select wslt."NAME" 
    , max(maxtemp-mintemp) as max_amplitude
from summary_of_weather_txt sowt
join weather_station_locations_txt wslt on sowt.sta = wslt.wban 
group by wslt."NAME"

--b. Z czym silniej skorelowana jest œrednia dzienna temperatura dla stacji – 
-- szerokoœci¹ (lattitude) czy d³ugoœci¹ (longtitude) geograficzn¹? (25%)

select corr(sowt.meantemp, wslt.latitude) as korelacja_szerokosc
    , corr(sowt.meantemp, wslt.longitude) as korelacja_dlugosc
from summary_of_weather_txt sowt 
join weather_station_locations_txt wslt on wslt.wban = sowt.sta;


--c) Poka¿ obserwacje, w których suma opadów atmosferycznych (precipitation) przekroczy³a 
-- sumê opadów z ostatnich 5 obserwacji na danej stacji. (25%)

select precip 
    , "Date"
    , wslt."NAME" 
from summary_of_weather_txt sowt 
join weather_station_locations_txt wslt on wslt.wban = sowt.sta 




-- d) Uszereguj stany/pañstwa wed³ug od najni¿szej temperatury zanotowanej tam w okresie 
-- obserwacji u¿ywaj¹c do tego funkcji okna (25%)

select dense_rank() over(order by min(sowt.mintemp)) as ranking
    , wslt."STATE/COUNTRY ID" 
    , min(sowt.mintemp) 
from summary_of_weather_txt sowt
join weather_station_locations_txt wslt  on sowt.sta = wslt.wban 
group by "STATE/COUNTRY ID"
order by min(sowt.mintemp) asc;


-- e) BONUS: czy gdzieœ mogliœmy doœwiadczyæ lipcowych opadów œniegu? (niespodzianka)

select wslt."STATE/COUNTRY ID" 
    , extract(month from "Date") as july
    , sum(sowt.snowfall) over(partition by wslt."STATE/COUNTRY ID" order by extract(month from "Date")) as œnieg
from summary_of_weather_txt sowt
join weather_station_locations_txt wslt on sowt.sta = wslt.wban 
group by sowt.snowfall, extract(month from "Date"), wslt."STATE/COUNTRY ID" 
having extract(month from "Date") = 7;

-- odpowiedŸ: Nigdzie nie doœwiadczono opadów œniegu w lipcu.
		
