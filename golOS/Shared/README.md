#  README

## TODO

### MapView

- get the time of the cursor position
- snap to hours (or half hours? or pentaminutes?)
	- maybe only add snapping for high-velocity?
- add haptics when scrolling past hours (or tetrahours?)

- make a func for positioning lines `Date()` & blocks `DateInterval()` on the map

- make the labels pretty
	- line markers: small ones for hour, medium ones for tetrahours
	- show text labels for "noon", "saturday", "noon", "sunday", ...
	- show number labels for tetrahours
	- make all the labels vertically centered with the middle of the line they correspond to

- add "go to now" button

### SolarView

- progressive information enhancement
	- tap to zoom in/ double tap to zoom out
	- when zoomed in show times, &c

- simplify intervals to night, dawn, day, dusk
- simplify points to sunrise, solarNoon, sunset, nadir



## IDEA

- add Rubber band effect at beginning and end of map to go back & forward in time (instead of infinite scroll) 
