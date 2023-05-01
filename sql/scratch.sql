
DROP TABLE IF EXISTS overlapping;
CREATE Table overlapping AS
SELECT distinct t1.*
FROM goffstown_line t1,
     goffstown_line t2
WHERE t1.osm_id <> t2.osm_id
  AND ST_Intersects(t1.way, t2.way)
  AND Upper(ST_GeometryType(ST_Intersection(t1.way, t2.way))) LIKE '%LINE%';

DROP TABLE IF EXISTS non_distinct;
CREATE Table non_distinct AS
SELECT *
FROM goffstown_line
WHERE osm_id IN
      (SELECT osm_id FROM goffstown_line GROUP BY osm_id HAVING COUNT(*) > 1);

SELECT count(DISTINCT)
From goffstown_line;


-- SElect way from planet_osm_polygon where name = 'Goffstown'
select st_srid(way) from goffstown_road_network;

DROP TABLE IF EXISTS goffstown_road;
CREATE Table goffstown_road AS
SELECT *
from planet_osm_roads
WHERE way &&
      '0103000020110F0000010000003F000000DF76779D256C5EC15CA845BE784B54419DEC39287B6B5EC1AB4454A280485441C54A53E4DA6B5EC10585BB2B6A4854418BDAB40FFA6B5EC1117D9E6C704754414ED01136136C5EC12D0D7074344754415EEF1E390C6C5EC12F608AEA2B47544172DF634AFF6B5EC1E96AC03B1D47544133062C35EF6B5EC15B03E2D71447544197722E70D76B5EC16E61F2B1114754412C8D4B91BD6B5EC1FD6D54330E475441424EC8B0AA6B5EC1E7B355270D475441A8791B1B9E6B5EC18B9A426512475441C4E81783986B5EC1FBF457D322475441892DD778906B5EC1AF8E480527475441F12962F17D6B5EC176E6A79224475441499A0C98756B5EC16A5BC29F1F475441E80D02A2726B5EC17D52100316475441C48870866E6B5EC14ED34A8A12475441E1FE44C26B6B5EC190EB0BEC13475441C26C93EB686B5EC1C6D127FA1B4754416062618B656B5EC1847C211C224754416B16327B5E6B5EC172D1080820475441568A54004D6B5EC1729D805618475441B4C678513E6B5EC18C7D9A0B124754410272FE6C396B5EC15E2B104F094754410643367B336B5EC18C24677AF7465441705DB8FE286B5EC17D4C4457ED4654417025FEC81D6B5EC1FE1E2CD4E7465441BD62A3DD1A6B5EC17A715B3EDE465441693519B588695EC184DB08A14B3F5441403CA79C11615EC19921B8EA0D40544173D0FA4F675C5EC1E1B0B1C2E6405441C2B32B33B55C5EC1429DF09D85425441A199501FC75C5EC13ACDE85CD3425441AD9F9B18EA5C5EC1F53676A996435441B4B9E1F7F25C5EC10AB81C79C7435441628CFD3A0E5D5EC11883967F5E445441045BDCDD345D5EC15DA4172D35455441B812AEC9355D5EC1F4DF8A4C3A455441C2EDE453365D5EC192B8574B3D45544134A4FCE9655D5EC102713DB2454654418E57EAC56A5D5EC1863AEFB4604654410010A52E6B5D5EC1F2DCC2F7624654413156AAA96C5D5EC17A078A326B465441E41805956F5D5EC13BDDB96A7B465441E3AA248E715D5EC1FE1F326186465441833539CF735D5EC18F2323EA92465441953FB8A89B5D5EC1F3B72D577047544104E254FBC35D5EC11B8B4264504854411F81268DC55D5EC1BEEC431B594854412496AE08CE5D5EC1F3B174D587485441D9DCFBF9D25D5EC1E06D3EB2A348544163488083D65D5EC16BC99F5AB7485441A05A825DD75D5EC12EDD6174BB4854410C30A4E4D85D5EC196AEC893C4485441FEB9C6A32E5E5EC1EDDCF6A8D94A54417C8C3B32855E5EC11FE6053CC14C5441E4A06C0E8F5E5EC148C69387014D5441B038B345B25E5EC17B8BF593B84D5441D96F173AE6695EC15D3B9D38E04B5441EB88C1D0566A5EC1377E69DBCE4B5441F81585E7086B5EC1C36E315EB24B5441DF76779D256C5EC15CA845BE784B5441'
  AND (access not in ('private', 'customers', 'military') or access is null)



DO $$
DECLARE
  col_name TEXT;
  null_count INTEGER;
BEGIN
  FOR col_name IN
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'goffstown_line'
  LOOP
    EXECUTE format('SELECT count(*) FROM goffstown_line WHERE %I IS NOT NULL', col_name)
    INTO null_count;
    IF null_count = 0 THEN
      EXECUTE format('ALTER TABLE goffstown_line DROP COLUMN %I', col_name);
    END IF;
  END LOOP;
END $$;

SELECT Distinct  access,
       bicycle,
       bridge,
       construction,
       foot,
       highway,
       horse,
       junction,
       layer,
       oneway,
       railway,
       route,
       surface,
       tracktype
from bike_roads;


select sum(st_length(way) * 0.000621371192)
    as miles from bike_roads;