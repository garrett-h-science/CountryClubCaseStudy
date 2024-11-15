/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

ANSWER:
	SELECT *
	FROM Facilities
	WHERE membercost > 0;

/* Q2: How many facilities do not charge a fee to members? */

ANSWER: Four facilities do not change a fee to members.

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

ANSWER: 
	SELECT facid, name, membercost, monthlymaintenance
	FROM Facilities
	WHERE membercost > 0
		AND monthlymaintenance * 0.2 > membercost;

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

ANSWER: 
	SELECT *
	FROM Facilities
	WHERE facid
		IN (1,5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

ANSWER:
	SELECT name, monthlymaintenance
	FROM Facilities
	WHERE monthlymaintenance > 100;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

ANSWER:
	SELECT MAX(joindate), surname, firstname
	FROM Members;

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

ANSWER:
        SELECT DISTINCT CONCAT(m.surname, ', ', m.firstname) AS person, f.name
    	FROM Bookings AS b
    	INNER JOIN Members AS m
        	ON b.memid = m.memid
    	INNER JOIN Facilities AS f
        	ON b.facid = f.facid
        WHERE f.facid IN (0,1)
        GROUP BY person
    	ORDER BY m.surname, m.firstname DESC;
2. Query all tasks
('Bader, Florence', 'Tennis Court 2')
('Baker, Timothy', 'Tennis Court 2')
('Baker, Anne', 'Tennis Court 1')
('Boothe, Tim', 'Tennis Court 2')
('Butters, Gerald', 'Tennis Court 1')
('Coplin, Joan', 'Tennis Court 1')
('Crumpet, Erica', 'Tennis Court 1')
('Dare, Nancy', 'Tennis Court 2')
('Farrell, Jemima', 'Tennis Court 2')
('Farrell, David', 'Tennis Court 1')
('GUEST, GUEST', 'Tennis Court 2')
('Genting, Matthew', 'Tennis Court 1')
('Hunt, John', 'Tennis Court 1')
('Jones, Douglas', 'Tennis Court 1')
('Jones, David', 'Tennis Court 2')
('Joplette, Janice', 'Tennis Court 1')
('Owen, Charles', 'Tennis Court 1')
('Pinker, David', 'Tennis Court 1')
('Purview, Millicent', 'Tennis Court 2')
('Rownam, Tim', 'Tennis Court 2')
('Rumney, Henrietta', 'Tennis Court 2')
('Sarwin, Ramnaresh', 'Tennis Court 2')
('Smith, Tracy', 'Tennis Court 1')
('Smith, Jack', 'Tennis Court 1')
('Smith, Darren', 'Tennis Court 2')
('Stibbons, Ponder', 'Tennis Court 2')
('Tracy, Burton', 'Tennis Court 2')


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


ANSWER:
    	SELECT f.name AS facility,
		CASE WHEN m.memid = 0 THEN 'GUEST'
		     ELSE CONCAT(m.surname, ', ', m.firstname) END AS name,
    		CASE WHEN b.memid = 0 THEN f.guestcost
		     ELSE f.membercost END AS cost
    	FROM Bookings AS b
        	INNER JOIN Facilities AS f
            		ON b.facid = f.facid
        	INNER JOIN Members AS m
            		ON b.memid = m.memid
        WHERE DATE(b.starttime) = '2012-09-14'
            AND cost > 30
        ORDER BY cost DESC;
2. Query all tasks
('Massage Room 1', 'GUEST', 80)
('Massage Room 1', 'GUEST', 80)
('Massage Room 1', 'GUEST', 80)
('Massage Room 2', 'GUEST', 80)

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

    	SELECT f.name AS facility, mb.name AS name, 
            CASE WHEN b.memid = 0 THEN f.guestcost
    		     ELSE f.membercost END AS cost
        FROM (SELECT b.facid AS facid, DATE(b.starttime) AS date,
                 CASE WHEN m.memid = 0 THEN 'GUEST'
        		      ELSE CONCAT(m.surname, ', ', m.firstname) END AS name,
              FROM Bookings AS b
              INNER JOIN Members AS m
             ON b.memid = m.memid) AS mb
        INNER JOIN Facilities AS f
        ON mb.facid = mb.facid
        WHERE mb.date = '2012-09-14'
            AND cost > 30
        ORDER BY cost DESC;

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing these files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

ANSWER:
        WITH cte AS
            (SELECT m.memid, f.name AS facility, CASE WHEN b.memid = 0 THEN f.guestcost ELSE f.membercost END AS cost
            FROM Bookings AS b
            INNER JOIN Facilities AS f ON b.facid = f.facid
            INNER JOIN Members AS m ON b.memid = m.memid)
        SELECT facility, SUM(cost) AS revenue
        FROM cte
        /* WHERE revenue < 1000.0 */
        GROUP BY facility
        ORDER BY revenue DESC;
2. Query all tasks
('Massage Room 1', 20807.9)
('Massage Room 2', 6987.3)
('Squash Court', 4970.0)
('Tennis Court 2', 4205)
('Tennis Court 1', 4040)
('Badminton Court', 604.5)
('Pool Table', 265)
('Snooker Table', 115)
('Table Tennis', 90)

/* Q11: Produce a report of members and who recommended them in alphabetic surname, firstname order */

ANSWER:
	SELECT 
            CASE WHEN m.recommendedby = '' THEN CONCAT(m.firstname, ' ', m.surname)
            ELSE CONCAT(m.firstname, ' ', m.surname, ' (', r.firstname, ' ', r.surname, ')') END AS statement
        FROM Members AS m
        LEFT JOIN Members AS r
        ON m.recommendedby = r.memid
        ORDER BY m.surname, m.firstname;
2. Query all tasks
('Florence Bader (Ponder Stibbons)',)
('Anne Baker (Ponder Stibbons)',)
('Timothy Baker (Jemima Farrell)',)
('Tim Boothe (Tim Rownam)',)
('Gerald Butters (Darren Smith)',)
('Joan Coplin (Timothy Baker)',)
('Erica Crumpet (Tracy Smith)',)
('Nancy Dare (Janice Joplette)',)
('David Farrell',)
('Jemima Farrell',)
('GUEST GUEST',)
('Matthew Genting (Gerald Butters)',)
('John Hunt (Millicent Purview)',)
('David Jones (Janice Joplette)',)
('Douglas Jones (David Jones)',)
('Janice Joplette (Darren Smith)',)
('Anna Mackenzie (Darren Smith)',)
('Charles Owen (Darren Smith)',)
('David Pinker (Jemima Farrell)',)
('Millicent Purview (Tracy Smith)',)
('Tim Rownam',)
('Henrietta Rumney (Matthew Genting)',)
('Ramnaresh Sarwin (Florence Bader)',)
('Darren Smith',)
('Darren Smith',)
('Jack Smith (Darren Smith)',)
('Tracy Smith',)
('Ponder Stibbons (Burton Tracy)',)
('Burton Tracy',)
('Hyacinth Tupperware',)
('Henry Worthington-Smyth (Tracy Smith)',)

/* Q12: Find the facilities with their usage by members, but not guests */

ANSWER:
        SELECT f.name, COUNT(b.memid)
        FROM Bookings AS b
        INNER JOIN Facilities AS f
        ON b.facid = f.facid
        WHERE b.memid <> 0
        GROUP BY b.facid;
2. Query all tasks
('Tennis Court 1', 308)
('Tennis Court 2', 276)
('Badminton Court', 344)
('Table Tennis', 385)
('Massage Room 1', 421)
('Massage Room 2', 27)
('Squash Court', 195)
('Snooker Table', 421)
('Pool Table', 783)

/* Q13: Find the facilities usage by month, but not guests */

ANSWER:
        SELECT f.name, STRFTIME('%m-%Y', b.starttime) AS month, COUNT(bookid)
        FROM Bookings AS b
        LEFT JOIN Facilities AS f
        ON b.facid = f.facid
        GROUP BY b.facid, month
        ORDER BY b.facid;
2. Query all tasks
('Tennis Court 1', '07-2012', 88)
('Tennis Court 1', '08-2012', 146)
('Tennis Court 1', '09-2012', 174)
('Tennis Court 2', '07-2012', 68)
('Tennis Court 2', '08-2012', 149)
('Tennis Court 2', '09-2012', 172)
('Badminton Court', '07-2012', 56)
('Badminton Court', '08-2012', 146)
('Badminton Court', '09-2012', 181)
('Table Tennis', '07-2012', 51)
('Table Tennis', '08-2012', 147)
('Table Tennis', '09-2012', 205)
('Massage Room 1', '07-2012', 123)
('Massage Room 1', '08-2012', 224)
('Massage Room 1', '09-2012', 282)
('Massage Room 2', '07-2012', 12)
('Massage Room 2', '08-2012', 40)
('Massage Room 2', '09-2012', 59)
('Squash Court', '07-2012', 75)
('Squash Court', '08-2012', 170)
('Squash Court', '09-2012', 195)
('Snooker Table', '07-2012', 75)
('Snooker Table', '08-2012', 159)
('Snooker Table', '09-2012', 210)
('Pool Table', '07-2012', 110)
('Pool Table', '08-2012', 291)
('Pool Table', '09-2012', 435)