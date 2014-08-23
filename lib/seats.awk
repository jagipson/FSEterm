func ddtorad(val) {
  return val * pi / 180.0
}
func radtodd(val) {
  return val * 180.0 / pi
}

func haversine(lat1, lng1, lat2, lng2) {
	dlon = lng1 - lng2
	dlat = lat1 - lat2
  f = sin(dlon/2.0) 
  g = sin(dlat/2.0) 
  a = (g*g) + cos(lat1) * cos(lat2) * (f*f) 
	c = 2.0 * atan2(sqrt(a), sqrt(1.0-a))
	d = R * c
  return d
}

func fwd_azimuth(lat1, lng1, lat2, lng2) {
	dlon = lng1 - lng2
	theta = atan2(sin(dlon)*cos(lat2), cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(dlon))
  return radtodd(theta)
}

BEGIN {
  FS=","
  PROCINFO["sorted_in"] = "@ind_str_asc"
  OFS=","

  R = 3443.89849 # radius of Sol III in nautical miles
  pi=3.14159265359

  # startup-time sanity checks
  direction=ENVIRON["direction"]
  minseats=ENVIRON["minseats"]
  icaodata=ENVIRON["icaodata"]
  if (! (direction && minseats && icaodata)) {
    print "error: one of direction, minseats, or icaodata ENV not set"
    print "direction", direction
    print "minseats", minseats
    print "icaodata", icaodata
    exit 1
  }

  # load lookup values
  while(getline < icaodata) {
    airport_lat[$1]=$2
    airport_lng[$1]=$3
    airport_name[$1]=$6
    airport_type[$1]=$4
  }
  close (icaodata)
}
# Skip the first line (contains header)
NR==1 { next; }

# If not a pax job, skip it
$6!="passengers" { next; }

# set directionallity. The "site' is any airpor to/from the main airport in
# query
direction=="from" { site=$3; qairport=$2 }
direction=="to" { site=$2; qairport=$3 } 

# Increment the PAX count for the site
{ pax[site]+= $5; }

END {
  if (direction=="from")
    printf ("To,")
  else
    printf ("From,")

  printf ("Field Name,Seats,NM,True Hdg\n")
  printf ("----,----------,-----,--,--------\n")

  for (site in pax)
    if (pax[site] >= minseats)
      printf ("%s,%s,%d,%.0f,%.0f\n", site, airport_name[site], pax[site], haversine(ddtorad(airport_lat[qairport]), ddtorad(airport_lng[qairport]), ddtorad(airport_lat[site]), ddtorad(airport_lng[site])), (360 - fwd_azimuth(ddtorad(airport_lat[qairport]), ddtorad(airport_lng[qairport]), ddtorad(airport_lat[site]), ddtorad(airport_lng[site]))) % 360)
}
