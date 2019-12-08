import numpy as np
import pandas as pd
import datetime as dt
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func, inspect

engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
#session = Session(engine)

#Flask set up

#Flask Dependencies - import flask and jsonify
from flask import Flask, jsonify

#Create an app being sure to pass __name__
app = Flask(__name__)

#Define Routes 
# what happens when user hits the index route

@app.route("/")
def welcome():
    #print(" Welcome to the Hawaiian Climate API Engine.")
    return (
        f"<bold>Welcome to the Hawaiian Climate API (data up to 2017-08-23)<br/><br/></bold>"
        f"<bold>Available Routes:<br/></bold>"
        f"/api/v1.0/precip<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/><br/>"
        f"<bold>Specific Date Range data:<br/></bold>"
        f"/api/v1.0/trip/start_date as YYYY-mm-dd<br/>"
        f"/api/v1.0/trip/start_date as YYYY-mm-dd/end_date as YYY-mm-dd<br/><br/>" 
        )

#Define what happens when user hits the precip route

@app.route("/api/v1.0/precip")

def precipdata():
    # Create our session (link) from Python to the DB
    session = Session(engine)

    #precipitation_df = helper.precipitation_data()
    # Design a query to retrieve the last 12 months of precipitation data and plot the results
    #2017-08-23 gets the last date
    max_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()

    # Calculate the date 1 year ago from the last data point in the database

    max_date = max_date[0]
    # The days are equal 366 so that the first day of the year is included - might need to use 365 vs 366
    year_ago = dt.datetime.strptime(max_date, "%Y-%m-%d") - dt.timedelta(days=366)


    # Perform a query to retrieve the data and precipitation scores

    query = session.query(Measurement.date, Measurement.prcp).filter(Measurement.date >= year_ago).all()

    session.close()

    return jsonify({k:v for k,v in query})
   
   # result = jsonify(precipitation_list)

   # return result

#Define what happens when user hits the station  route

@app.route("/api/v1.0/stations")

def stationdata():

    # Create our session (link) from Python to the DB
    session = Session(engine)

    # List the stations and the counts in descending order.
    active_stations = session.query(Measurement.station,func.count(Measurement.station)).group_by(Measurement.station).order_by(func.count(Measurement.station).desc()).all()

    result = jsonify(active_stations)
    session.close()

    return result

#Define what happens when user hits the tobs route

@app.route("/api/v1.0/tobs")

def tobsdata():

    # Create our session (link) from Python to the DB
    session = Session(engine)

    # Design a query to retrieve the last 12 months of precipitation data and plot the results
    #2017-08-23 gets the last date
    max_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()

    # Calculate the date 1 year ago from the last data point in the database
    max_date = max_date[0]

    # The days are equal 366 so that the first day of the year is included - might need to use 365 vs 366
    year_ago = dt.datetime.strptime(max_date, "%Y-%m-%d") - dt.timedelta(days=366)

    #Update the 'Measurement' table and subsitute the "prcp" with 0.0 where there is Null values or None values
    engine.execute("Update Measurement SET prcp=0.0 WHERE prcp is NULL")
    tobs = session.query(Measurement.station,Measurement.date, Measurement.prcp, Measurement.tobs).filter(Measurement.date >= year_ago).all()

    results = jsonify(tobs)

    session.close()

    return results

#Define what happens when user hits the trip date route

@app.route("/api/v1.0/trip/<start>")
@app.route("/api/v1.0/trip/<start>/<end>")

def tripdata(start = None,end="2017-08-23"):
    # Create our session (link) from Python to the DB
    session = Session(engine)

    start = dt.datetime.strptime(start, "%Y-%m-%d")
    end =dt.datetime.strptime(end, "%Y-%m-%d")


    # Use the start and end date to create a range of dates
    dates = session.query(Measurement.date).filter(Measurement.date >= start).filter(Measurement.date <= end).group_by(Measurement.date).all()
    #trip_dates = [x[0] for x in dates]

    # Loop through the list of %m-%d strings and calculate the normals for each date
    daily_normals = [session.query(func.min(Measurement.tobs),func.avg(Measurement.tobs),func.max(Measurement.tobs)).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) >= start).filter(func.strftime("%Y-%m-%d", Measurement.date) <= end).\
    group_by(func.strftime("%Y-%m-%d", Measurement.date)).all()]

    daily_normals = daily_normals[0]

    result = jsonify(daily_normals)
    session.close()

    return result



if __name__ == "__main__":

    app.run(debug=True)