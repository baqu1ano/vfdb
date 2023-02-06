component displayname="VFDBEventDAO" output="false" {

    public string function addEditEvent(required eventinfo) {
        var obj = deserializeJSON(eventinfo);
        var ret = {};
        
        chkqry = queryExecute(
            "
                SELECT id
                FROM event_list
                WHERE event_name = :ename
            ",{
                ename: obj.event_name
            },{
                datasource = session.vfdb_calcdb
            } 
        );

        if (chkqry.recordcount GT 0) {
            ret["id"] = chkqry.id;
            updqry = queryExecute(
                "
                UPDATE event_list
                SET event_date = ?,
                    event_name = ?,
                    event_type = ?,
                    event_edition = ?,
                    event_description = ?,
                    event_page = ?,
                    organizer = ?,
                    site = ?
                WHERE id = ?
                ",{
                    [obj.event_date,obj.event_name,obj.event_type,obj.event_edition,
                        obj.event_description,obj.event_page,obj.organizer,obj.site,ret.id]
                },{
                    datasource = session.vfdb_calcdb
                }
            );
        } else {
            ret["id"] = 0;
        }
    }

    return serializeJSON(ret);
}

/*
{
    "event_date": "2023-02-04 06:00:00",
    "event_name": "Un Buen Largo",
    "event_type": "Trail",
    "event_edition": 1,
    "event_description": "Scenic Mountain",
    "event_page": "",
    "organizer": 6,
    "site": 4,
    "modes": [
        {
            "mode_date": "2023-02-04 07:30",
            "distance": 14,
            "capacity": 200,
            "cost": 7,
            "real_distance": 15.109999999999999432,
            "min_elevation": 534,
            "max_elevation": 883,
            "ascent": 612,
            "descent": 612,
            "route_link": "",
            "gpx_link": ""
        },
        {
            "mode_date": "2023-02-04 07:30",
            "distance": 22,
            "capacity": 200,
            "cost": 7,
            "real_distance": 24.010000000000001563,
            "min_elevation": 534,
            "max_elevation": 883,
            "ascent": 717,
            "descent": 717,
            "route_link": "",
            "gpx_link": ""
        }
    ]
}
*/