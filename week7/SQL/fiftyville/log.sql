-- Keep a log of any SQL queries you execute as you solve the mystery.

--Task
--All you know is that the theft took place on July 28, 2021
--it took place on Humphrey Street.

--Plan:
--Version-1 --The suspect has used own car
--Analysing result there are enough evidences to prove that:
----Suspect: Bruce -> flight 08:20 -> New York City
----                | He was on bakery parking and left at 10.18 - 3 minute later than theft
----                | He was at ATM on 28 July
----                | He has an early flight to New York
----                | He has a proven relationship with Robin for 28 July
----Complice: Robin
----                | Prove - phone call less than 1 minute

--Version-2 --The suspect has used complice car
--Analysing the flight data the most apropiate to scenario is
--Batista as a principal suspect and Aaron as complice with
--destination Los Angeles, but not enough evidence to prove.

--Version-3 --The suspect or complice are not documented well (missing passport, phone, car in DB)
    -- Analysing with the call + flight + ATM + Parking data the conclusion is:
    -- Suspects: Diana | strong evidence
    -- Destination: Dallas
    -- Potential complice: Robin | No strong evidence



--1. Read the Police report about the crime
SELECT description FROM crime_scene_reports
WHERE day="28" AND month="07" AND year="2021"
AND street="Humphrey Street";
--RESULT:
--Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery.
--Interviews were conducted today with three witnesses who were present at the time
--– each of their interview transcripts mentions the bakery. |
--Littering took place at 16:36. No known witnesses.
---------------------------------------------------------------
--INFO:
--day="28"
--month="07"
--year="2021"
--hour="10"
--minute="15"
--street="Humphrey Street"
--object="CS50 duck"
--littering at 16:36
--interviews="3"
--mentions="bakery"

-----------------------------------------------------------------------------------------

--2. Read the notes about the interviews conducted at the location mentioning bakery

SELECT  people.name, transcript FROM interviews
JOIN people ON people.name=interviews.name
WHERE day="28" AND month="07" AND year="2021"
AND transcript LIKE "%bakery%";

--RESULT:
--|  name   |                                                                                                                                                     transcript                                                                                                                                                      |
--+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
--| Ruth    | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
--| Eugene  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
--| Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |

----------------
--Updated info
--day="28"
--month="07"
--year="2021"
--hour="10"
--minute="15"
--street="Humphrey Street"
--interviews="3"
--mentions="bakery"

--bakery parking
--timeframe 10 minute after the suspect left the car park with a car

--ATM on Leggett Street
-- timeframe to 10:15, the suspect withdraw money

--bakery
--suspect recieved a call less than 1 min duration, timeframe 10.15-10.20

--earliest outbound flight on 29 July
--the 2 suspect to book flight, timeframe from 10.15, on 28 July

------------------------------------------------------------------------------------------------------------------

--3. Check the bakery parking logs for people living from 10.15 to 10.30

SELECT bakery_security_logs.hour, bakery_security_logs.minute, bakery_security_logs.activity, bakery_security_logs.license_plate, people.name
FROM bakery_security_logs
JOIN people ON people.license_plate = bakery_security_logs.license_plate
WHERE day="28" AND month="07" AND year="2021";

--Result
--Extract
-- 10   | 16     | exit     | 5P2BI95       | Vanessa |
-- 10   | 18     | exit     | 94KL13X       | Bruce   |
-- 10   | 18     | exit     | 6P58WS2       | Barry   |
-- 10   | 19     | exit     | 4328GD8       | Luca    |
-- 10   | 20     | exit     | G412CB7       | Sofia   |
-- 10   | 21     | exit     | L93JTIZ       | Iman    |
-- 10   | 23     | exit     | 322W7JE       | Diana   |
-- 10   | 23     | exit     | 0NTHK55       | Kelsey  |

--Suspects: Vanessa, Bruce, Barry, Luca, Sofia, Iman, Diana, Kelsey
------------------------------------------------------------------------------------

-- 4. Check the  withdraws on ATM on Leggett Street on matches with the list on leaving the parking

SELECT DISTINCT(name), phone_number, passport_number, license_plate FROM people
JOIN bank_accounts ON bank_accounts.person_id=people.id
JOIN atm_transactions ON atm_transactions.account_number=bank_accounts.account_number
WHERE atm_transactions.day="28" AND atm_transactions.month="07" AND atm_transactions.year="2021"
AND atm_transactions.atm_location="Leggett Street"
AND people.name="Vanessa" OR people.name="Bruce" OR people.name="Barry" OR people.name="Luca"
OR people.name="Sofia" OR people.name="Iman" OR people.name="Diana" OR people.name="Kelsey";

--Result:
-- name  |  phone_number  | passport_number | license_plate |
-- Bruce | (367) 555-5533 | 5773159633      | 94KL13X       |
-- Diana | (770) 555-1861 | 3592750733      | 322W7JE       |
-- Iman  | (829) 555-5269 | 7049073643      | L93JTIZ       |
-- Luca  | (389) 555-5198 | 8496433585      | 4328GD8       |
-- Barry | (301) 555-4174 | 7526138472      | 6P58WS2       |


--Suspects: Bruce, Barry, Luca, Iman, Diana
-------------------------------------------------------------------------------------------------

-- 5.
-- a.Check if someone in the list has recived a call with duration less than 1 minute

SELECT DISTINCT(name) FROM people
JOIN phone_calls ON phone_calls.receiver=people.phone_number
WHERE phone_calls.day="28" AND phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60
AND people.name="Bruce" OR people.name="Diana" OR people.name="Iman"
OR people.name="Luca" OR people.name="Barry";

--Result:

| name  |
+-------+
| Barry |
| Iman  |
| Luca  |
| Diana |
+-------+

-- b. Check if someone in the list has made a call with duration less than 1 minute

SELECT DISTINCT(name) FROM people
JOIN phone_calls ON phone_calls.caller=people.phone_number
WHERE phone_calls.day="28" AND phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60
AND people.name="Bruce" OR people.name="Diana" OR people.name="Iman"
OR people.name="Luca" OR people.name="Barry";

--Results:
| name  |
+-------+
| Barry |
| Iman  |
| Luca  |
| Diana |
| Bruce |
+-------+

--Suspects: Bruce, Barry, Luca, Iman, Diana
----------------------------------------------------------------------------------------------------

-- 6. Check if someone from last list has a flight on 29 July and where


SELECT DISTINCT(people.name), people.passport_number, flights.id, flights.hour,
flights.minute, flights.origin_airport_id, flights.destination_airport_id, passengers.seat FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON airports.id=flights.origin_airport_id
WHERE flights.day="29" AND flights.month="07" AND flights.year="2021"
AND people.name="Barry" OR people.name="Iman" OR people.name="Luca"
OR people.name="Diana" OR people.name="Bruce" ORDER BY flights.hour, flights.minute;


--Result:

--| name  | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+-------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Bruce | 5773159633      | 36 | 8    | 20     | 8                 | 4                      | 4A   |
--| Luca  | 8496433585      | 36 | 8    | 20     | 8                 | 4                      | 7B   |
--| Diana | 3592750733      | 54 | 10   | 19     | 8                 | 5                      | 6C   |
--| Luca  | 8496433585      | 11 | 13   | 7      | 8                 | 12                     | 5D   |
--| Iman  | 7049073643      | 26 | 13   | 32     | 2                 | 8                      | 2C   |
--| Diana | 3592750733      | 18 | 16   | 0      | 8                 | 6                      | 4C   |
--| Diana | 3592750733      | 24 | 16   | 27     | 7                 | 8                      | 2C   |
--| Luca  | 8496433585      | 48 | 18   | 28     | 5                 | 8                      | 7C   |

--7. Checking the airports id for analysis

SELECT DISTINCT(id), city FROM airports
WHERE id < 13;

--| id |     city      |
--| 1  | Chicago       |
--| 2  | Beijing       |
--| 3  | Los Angeles   |
--| 4  | New York City |
--| 5  | Dallas        |
--| 6  | Boston        |
--| 7  | Dubai         |
--| 8  | Fiftyville    |
--| 9  | Tokyo         |
--| 10 | Paris         |
--| 11 | San Francisco |
--| 12 | Delhi         |

--Conclusion: Diana is leaving city on later flight to Dallas, Iman has an inbound flight from Beijing, Barry has no flight


--Suspects: Bruce, Luca on the same flight 08:20 -> New York City

-- Check their relationship

--Inbound calls for Bruce
SELECT people.name, phone_calls.receiver, phone_calls.caller FROM people
JOIN phone_calls ON phone_calls.receiver=people.phone_number
WHERE phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.day="28"
AND people.name="Bruce";
+-------+----------------+----------------+
| name  |    receiver    |     caller     |
+-------+----------------+----------------+

--Inbound calls for Luca
SELECT people.name, phone_calls.receiver, phone_calls.caller FROM people
JOIN phone_calls ON phone_calls.receiver=people.phone_number
WHERE phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60
AND phone_calls.day="28"
AND people.name="Luca";
--Result:
+------+----------------+----------------+
| name |    receiver    |     caller     |
+------+----------------+----------------+|

--Outbound calls for Bruce less than 1 min
SELECT people.name, phone_calls.caller, phone_calls.receiver FROM people
JOIN phone_calls ON phone_calls.caller=people.phone_number
WHERE phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60
AND phone_calls.day="28"
AND phone_calls.caller="(367) 555-5533";

--Result:
+-------+----------------+----------------+
| name  |     caller     |    receiver    |
+-------+----------------+----------------+
| Bruce | (367) 555-5533 | (375) 555-8161 |
+-------+----------------+----------------+

SELECT name FROM people
WHERE phone_number="(375) 555-8161";
--Results:
 name  |
+-------+
| Robin |

--Outbound calls for Luca
SELECT people.name, phone_calls.caller, phone_calls.receiver FROM people
JOIN phone_calls ON phone_calls.caller=people.phone_number
WHERE phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60
AND phone_calls.day="28"
AND phone_calls.caller="(389) 555-5198";
--Results: No outbound calls


----Suspect 1: Bruce -> flight 08:20 -> New York City | No relationship with Luca
----Complice: Robin | phone call less than 1 minute on 28 July
----Suspect 2: Luca  -> flight 08:20 -> New York City
----Complice: N/A
----Conclusion: Suspect 1 is the main suspect as it has a complice while Luca had no phone contacts on 28 July
----------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
--Version 2:
-- Step 1 and 2 the same

-- 3 Check the  withdraws on ATM on Leggett Street

SELECT DISTINCT(name), phone_number, passport_number, license_plate FROM people
JOIN bank_accounts ON bank_accounts.person_id=people.id
JOIN atm_transactions ON atm_transactions.account_number=bank_accounts.account_number
WHERE atm_transactions.day="28" AND atm_transactions.month="07" AND atm_transactions.year="2021"
AND atm_transactions.atm_location="Leggett Street";

--Result
--|  name   |  phone_number  | passport_number | license_plate |
--+---------+----------------+-----------------+---------------+
--| Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
--| Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       |
--| Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
--| Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
--| Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       |
--| Kaelyn  | (098) 555-1164 | 8304650265      | I449449       |
--| Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
--| Benista | (338) 555-6650 | 9586786673      | 8X428L0       |
--| Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |

-- Suspects: Luca, Kenny, Taylor, Bruce, Brooke, Kaelyn, Iman, Benista, Diana
----------------------------------------------------------------------------------

--4 Check if someone in the list has recived a call with duration less than 1 minute and the caller

SELECT DISTINCT(name), phone_number, passport_number, license_plate, phone_calls.caller FROM people
JOIN phone_calls ON phone_calls.receiver=people.phone_number
WHERE phone_calls.day="28" AND phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60
AND people.name="Luca" OR people.name="Kenny" OR people.name="Taylor"
OR people.name="Bruce" OR people.name="Brooke" OR people.name="Kaelyn"
OR people.name="Iman" OR people.name="Benista" OR people.name="Diana";

--Result:
--+---------+----------------+-----------------+---------------+----------------+
--|  name   |  phone_number  | passport_number | license_plate |     caller     |
--+---------+----------------+-----------------+---------------+----------------+
--| Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       | (328) 555-9658 |
--| Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       | (751) 555-6567 |
--| Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       | (984) 555-5921 |
--| Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | (243) 555-7229 |
--| Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | (321) 555-6083 |
--| Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | (328) 555-1152 |
--| Benista | (338) 555-6650 | 9586786673      | 8X428L0       | (204) 555-4136 |
--| Benista | (338) 555-6650 | 9586786673      | 8X428L0       | (420) 555-5821 |
--| Benista | (338) 555-6650 | 9586786673      | 8X428L0       | (695) 555-0348 |
--| Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | (060) 555-2489 |
--| Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | (487) 555-5865 |
--| Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | (771) 555-7880 |
--| Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       | (190) 555-4928 |
--| Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       | (406) 555-4440 |
--| Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       | (604) 555-0153 |
--| Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | (031) 555-9915 |
--| Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | (068) 555-0183 |
--| Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | (499) 555-9472 |
--| Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | (020) 555-6715 |
--| Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | (695) 555-0348 |
--| Kaelyn  | (098) 555-1164 | 8304650265      | I449449       | (336) 555-0077 |
--| Kaelyn  | (098) 555-1164 | 8304650265      | I449449       | (452) 555-8550 |
--| Kaelyn  | (098) 555-1164 | 8304650265      | I449449       | (749) 555-4874 |
--+---------+----------------+-----------------+---------------+----------------+

-- Suspects: Kenny, Taylor, Bruce, Brooke, Kaelyn, Iman, Benista, Diana
----------------------------------------------------------------------------------

--5 Check if someone from last list has a flight on 29 July morning and to where

SELECT DISTINCT(people.name), people.passport_number, flights.id, flights.hour,
flights.minute, flights.origin_airport_id, flights.destination_airport_id, passengers.seat FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON airports.id=flights.origin_airport_id
WHERE flights.day="29" AND flights.month="07" AND flights.year="2021"
AND people.name="Kenny" OR people.name="Taylor" OR people.name="Bruce"
OR people.name="Brooke" OR people.name="Kaelyn" OR people.name="Iman"
OR people.name="Benista" OR people.name="Diana" ORDER BY flights.hour, flights.minute;

--Result:
--+---------+-----------------+----+------+--------+-------------------+------------------------+------+
--|  name   | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+---------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Bruce   | 5773159633      | 36 | 8    | 20     | 8                 | 4                      | 4A   |
--| Taylor  | 1988161715      | 36 | 8    | 20     | 8                 | 4                      | 6D   |
--| Kenny   | 9878712108      | 36 | 8    | 20     | 8                 | 4                      | 7A   |
--| Diana   | 3592750733      | 54 | 10   | 19     | 8                 | 5                      | 6C   |
--| Benista | 9586786673      | 5  | 11   | 45     | 8                 | 3                      | 7A   |
--| Benista | 9586786673      | 42 | 13   | 22     | 4                 | 8                      | 9B   |
--| Iman    | 7049073643      | 26 | 13   | 32     | 2                 | 8                      | 2C   |
--| Brooke  | 4408372428      | 53 | 15   | 20     | 8                 | 9                      | 3D   |
--| Brooke  | 4408372428      | 20 | 15   | 22     | 6                 | 8                      | 2D   |
--| Diana   | 3592750733      | 18 | 16   | 0      | 8                 | 6                      | 4C   |
--| Diana   | 3592750733      | 24 | 16   | 27     | 7                 | 8                      | 2C   |
--| Brooke  | 4408372428      | 17 | 20   | 16     | 8                 | 4                      | 9D   |
--+---------+-----------------+----+------+--------+-------------------+------------------------+------+


--------------------------------------------------------------------------------------------------------
--6. Checking the airports id for analysis

SELECT DISTINCT(id), city FROM airports
WHERE id < 13;

--| id |     city      |
--| 1  | Chicago       |
--| 2  | Beijing       |
--| 3  | Los Angeles   |
--| 4  | New York City |
--| 5  | Dallas        |
--| 6  | Boston        |
--| 7  | Dubai         |
--| 8  | Fiftyville    |
--| 9  | Tokyo         |
--| 10 | Paris         |
--| 11 | San Francisco |
--| 12 | Delhi         |

-- 5 and 6 Conclusion
-- The first 5 flight from Fiftyvile bring attention as are in the morning hours, that reduce the list of suspects to 5.

-- Suspects: Kenny, Taylor, Bruce, Benista, Diana

--7 Check if someone from their caller have a ticket for the morning flights from step 4

-- Theory 1 - the suspect and complice fligh with the same plane
-- For Kenny
SELECT DISTINCT(people.name), people.passport_number, flights.id, flights.hour,
flights.minute, flights.origin_airport_id, flights.destination_airport_id, passengers.seat FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON airports.id=flights.origin_airport_id
WHERE flights.day="29" AND flights.month="07" AND flights.year="2021"
AND people.phone_number="(328) 555-9658" OR people.phone_number="(751) 555-6567"
OR people.phone_number="(984) 555-5921"
OR people.name="Kenny" ORDER BY flights.hour, flights.minute;

-- Result: No matches
--+--------+-----------------+----+------+--------+-------------------+------------------------+------+
--|  name  | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+--------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Kenny  | 9878712108      | 36 | 8    | 20     | 8                 | 4                      | 7A   |
--| Jordan | 7951366683      | 23 | 12   | 15     | 8                 | 11                     | 6B   |
--| Peter  | 9224308981      | 2  | 12   | 44     | 2                 | 8                      | 7B   |
--| Randy  | 7538263720      | 33 | 17   | 58     | 6                 | 8                      | 2C   |
--| Peter  | 9224308981      | 39 | 22   | 37     | 5                 | 8                      | 9D   |
--+--------+-----------------+----+------+--------+-------------------+------------------------+------+

-- Suspects: Taylor, Bruce, Benista, Diana

--For Taylor
SELECT DISTINCT(people.name), people.passport_number, flights.id, flights.hour,
flights.minute, flights.origin_airport_id, flights.destination_airport_id, passengers.seat FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON airports.id=flights.origin_airport_id
WHERE flights.day="29" AND flights.month="07" AND flights.year="2021"
AND people.phone_number="(060) 555-2489" OR people.phone_number="(487) 555-5865"
OR people.phone_number="(771) 555-7880"
OR people.name="Taylor" ORDER BY flights.hour, flights.minute;

--Results: No matches
--+--------+-----------------+----+------+--------+-------------------+------------------------+------+
--|  name  | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+--------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Ralph  | 6464352048      | 49 | 8    | 5      | 8                 | 6                      | 9A   |
--| Taylor | 1988161715      | 36 | 8    | 20     | 8                 | 4                      | 6D   |
--| Kayla  | 4674590724      | 56 | 18   | 24     | 4                 | 8                      | 7A   |
--| Ralph  | 6464352048      | 12 | 18   | 57     | 2                 | 8                      | 7C   |
--+--------+-----------------+----+------+--------+-------------------+------------------------+------+

-- Suspects: Bruce, Benista, Diana

--For Bruce
SELECT DISTINCT(people.name), people.passport_number, flights.id, flights.hour,
flights.minute, flights.origin_airport_id, flights.destination_airport_id, passengers.seat FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON airports.id=flights.origin_airport_id
WHERE flights.day="29" AND flights.month="07" AND flights.year="2021"
AND people.phone_number="(020) 555-6715" OR people.phone_number="(695) 555-0348"
OR people.phone_number="(771) 555-7880"
OR people.name="Bruce" ORDER BY flights.hour, flights.minute;

-- Results: No matches
--+-------+-----------------+----+------+--------+-------------------+------------------------+------+
--| name  | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+-------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Ralph | 6464352048      | 49 | 8    | 5      | 8                 | 6                      | 9A   |
--| Bruce | 5773159633      | 36 | 8    | 20     | 8                 | 4                      | 4A   |
--| Jean  | 1682575122      | 42 | 13   | 22     | 4                 | 8                      | 6D   |
--| Jean  | 1682575122      | 6  | 13   | 49     | 8                 | 5                      | 4B   |
--| Jean  | 1682575122      | 35 | 16   | 16     | 8                 | 4                      | 3D   |
--| Ralph | 6464352048      | 12 | 18   | 57     | 2                 | 8                      | 7C   |
--+-------+-----------------+----+------+--------+-------------------+------------------------+------+

-- Suspects: Benista, Diana

-- For Benista
SELECT DISTINCT(people.name), people.passport_number, flights.id, flights.hour,
flights.minute, flights.origin_airport_id, flights.destination_airport_id, passengers.seat FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON airports.id=flights.origin_airport_id
WHERE flights.day="29" AND flights.month="07" AND flights.year="2021"
AND people.phone_number="(204) 555-4136" OR people.phone_number="(420) 555-5821"
OR people.phone_number="(695) 555-0348"
OR people.name="Benista" ORDER BY flights.hour, flights.minute;

-- Results: No matches
--+---------+-----------------+----+------+--------+-------------------+------------------------+------+
--|  name   | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+---------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Benista | 9586786673      | 5  | 11   | 45     | 8                 | 3                      | 7A   |
--| Aaron   | 9852889341      | 44 | 13   | 19     | 8                 | 3                      | 2D   |
--| Benista | 9586786673      | 42 | 13   | 22     | 4                 | 8                      | 9B   |
--| Jean    | 1682575122      | 42 | 13   | 22     | 4                 | 8                      | 6D   |
--| Jean    | 1682575122      | 6  | 13   | 49     | 8                 | 5                      | 4B   |
--| Aaron   | 9852889341      | 57 | 14   | 30     | 3                 | 8                      | 6C   |
--| Jean    | 1682575122      | 35 | 16   | 16     | 8                 | 4                      | 3D   |
--| Aaron   | 9852889341      | 8  | 20   | 56     | 8                 | 2                      | 8A   |
--| Aaron   | 9852889341      | 28 | 22   | 49     | 3                 | 8                      | 6B   |
--+---------+-----------------+----+------+--------+-------------------+------------------------+------+

-- Suspects: Diana

--For Diana
SELECT DISTINCT(people.name), people.passport_number, flights.id, flights.hour,
flights.minute, flights.origin_airport_id, flights.destination_airport_id, passengers.seat FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
JOIN flights ON flights.id = passengers.flight_id
JOIN airports ON airports.id=flights.origin_airport_id
WHERE flights.day="29" AND flights.month="07" AND flights.year="2021"
AND people.phone_number="(031) 555-9915" OR people.phone_number="(068) 555-0183"
OR people.phone_number="(499) 555-9472"
OR people.name="Diana" ORDER BY flights.hour, flights.minute;

-- Results: No matches

--+----------+-----------------+----+------+--------+-------------------+------------------------+------+
--|   name   | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+----------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Kelsey   | 8294398571      | 36 | 8    | 20     | 8                 | 4                      | 6C   |
--| Diana    | 3592750733      | 54 | 10   | 19     | 8                 | 5                      | 6C   |
--| Margaret | 1782675901      | 14 | 12   | 8      | 5                 | 8                      | 2A   |
--| Diana    | 3592750733      | 18 | 16   | 0      | 8                 | 6                      | 4C   |
--| Diana    | 3592750733      | 24 | 16   | 27     | 7                 | 8                      | 2C   |
--| Margaret | 1782675901      | 51 | 18   | 3      | 4                 | 8                      | 4C   |
--+----------+-----------------+----+------+--------+-------------------+------------------------+------+

--Conclusion: Theory with the same plane fails

--Theory 2: Different planes - the same distination

--+---------+-----------------+----+------+--------+-------------------+------------------------+------+
--|  name   | passport_number | id | hour | minute | origin_airport_id | destination_airport_id | seat |
--+---------+-----------------+----+------+--------+-------------------+------------------------+------+
--| Benista | 9586786673      | 5  | 11   | 45     | 8                 | 3                      | 7A   |
--| Aaron   | 9852889341      | 44 | 13   | 19     | 8                 | 3                      | 2D   |

--Checking the airports id for analysis

SELECT DISTINCT(id), city FROM airports
WHERE id < 13;

--| id |     city      |
--| 1  | Chicago       |
--| 2  | Beijing       |
--| 3  | Los Angeles   |
--| 4  | New York City |
--| 5  | Dallas        |
--| 6  | Boston        |
--| 7  | Dubai         |
--| 8  | Fiftyville    |
--| 9  | Tokyo         |
--| 10 | Paris         |
--| 11 | San Francisco |
--| 12 | Delhi         |

--Conclusion Theory 2
--Analysing the flight data the most apropiate to scenario is Batista as a principal suspect and Aaron with destination Los Angeles, but no strong evidence

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

--Version-3 --The suspect or complice are not documented well (missing passport, phone, car in DB)

--Facts:
    --Supect: has a phone, passport
    --Complice: has a phone

--3 Check the bakery security logs on cars living the parking between 10:00 and 11:00


SELECT bakery_security_logs.license_plate, bakery_security_logs.activity,
bakery_security_logs.hour, bakery_security_logs.minute, people.id, people.name
FROM bakery_security_logs
JOIN people ON people.license_plate = bakery_security_logs.license_plate
WHERE day="28" AND month="07" AND year="2021" AND hour="10"
AND activity="exit" GROUP BY minute;

--Results:

+---------------+----------+------+--------+--------+---------+
| license_plate | activity | hour | minute |   id   |  name   |
+---------------+----------+------+--------+--------+---------+
| 5P2BI95       | exit     | 10   | 16     | 221103 | Vanessa |
| 94KL13X       | exit     | 10   | 18     | 686048 | Bruce   |
| 4328GD8       | exit     | 10   | 19     | 467400 | Luca    |
| G412CB7       | exit     | 10   | 20     | 398010 | Sofia   |
| L93JTIZ       | exit     | 10   | 21     | 396669 | Iman    |
| 322W7JE       | exit     | 10   | 23     | 514354 | Diana   |
| 1106N58       | exit     | 10   | 35     | 449774 | Taylor  |
+---------------+----------+------+--------+--------+---------+

--4 Check the ATM transactions
SELECT DISTINCT(atm_transactions.account_number), atm_transactions.amount,
people.id, people.name FROM atm_transactions
JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number
JOIN people ON people.id=bank_accounts.person_id
WHERE day="28" AND month="07" AND year="2021"
AND transaction_type="withdraw";

--Result:
| account_number | amount |   id   |   name    |
+----------------+--------+--------+-----------+
| 90209473       | 45     | 632023 | Amanda    |
| 28500762       | 48     | 467400 | Luca      |
| 41935128       | 15     | 713341 | Donna     |
| 45468795       | 15     | 952462 | Christian |
| 57029719       | 80     | 743806 | Sharon    |
| 66454844       | 60     | 622544 | Joe       |
| 16113845       | 55     | 748674 | Jeremy    |
| 66344537       | 55     | 506435 | Zachary   |
| 97773635       | 85     | 682850 | Ethan     |
| 92647903       | 5      | 341739 | Rebecca   |
| 99835463       | 40     | 534459 | Olivia    |
| 67735369       | 20     | 834626 | Shirley   |
| 40665580       | 35     | 769190 | Charles   |
| 19531272       | 55     | 650560 | Rose      |
| 28296815       | 20     | 395717 | Kenny     |
| 96336648       | 20     | 274893 | Christina |
| 76054385       | 60     | 449774 | Taylor    |
| 49610011       | 50     | 686048 | Bruce     |
| 92206742       | 30     | 585903 | Arthur    |
| 16153065       | 80     | 458378 | Brooke    |
| 20774848       | 40     | 423393 | Carol     |
| 21656307       | 10     | 447494 | Dennis    |
| 69638157       | 20     | 567218 | Jack      |
| 13156006       | 15     | 920334 | Stephen   |
| 89843009       | 40     | 274388 | Laura     |
| 69278040       | 45     | 379932 | Joshua    |
| 92647903       | 40     | 341739 | Rebecca   |
| 57022441       | 55     | 757606 | Douglas   |
| 75571594       | 40     | 907148 | Carina    |
| 16654966       | 100    | 205082 | Pamela    |
| 25506511       | 20     | 396669 | Iman      |
| 62690806       | 45     | 526940 | Hannah    |
| 79165736       | 5      | 637069 | Michelle  |
| 76849114       | 10     | 293753 | Ryan      |
| 66254725       | 70     | 225259 | Sean      |
| 74812642       | 60     | 231387 | Margaret  |
| 70992522       | 25     | 504758 | Samantha  |
| 66344537       | 60     | 506435 | Zachary   |
| 55656186       | 95     | 753885 | Jennifer  |
| 50380485       | 100    | 572028 | Paul      |
| 93401152       | 65     | 620295 | Janet     |
| 46222318       | 60     | 539960 | Theresa   |
| 58673910       | 10     | 229572 | Ernest    |
| 93903397       | 35     | 704850 | Rachel    |
| 81061156       | 30     | 438727 | Benista   |
| 79127781       | 65     | 837455 | Andrew    |
| 95773068       | 45     | 630782 | Alexis    |
| 57022441       | 85     | 757606 | Douglas   |
| 15452229       | 25     | 337221 | Christine |
| 40231842       | 5      | 271242 | Albert    |
| 26797365       | 35     | 929343 | Andrea    |
| 87859883       | 5      | 623724 | Julia     |
| 40665580       | 65     | 769190 | Charles   |
| 47306903       | 90     | 651217 | Alan      |
| 34939061       | 100    | 985539 | Lisa      |
| 26191313       | 90     | 490439 | Jesse     |
| 59116006       | 40     | 681821 | David     |
| 65190958       | 50     | 779942 | Harold    |
| 99031604       | 20     | 336397 | Joan      |
| 26013199       | 35     | 514354 | Diana     |
| 58552019       | 30     | 652412 | Denise    |
| 17171330       | 15     | 850016 | Mark      |
| 14180174       | 95     | 764823 | Keith     |
| 97338436       | 60     | 545303 | Nicholas  |
| 55322348       | 5      | 484375 | Anna      |


--5 Check the phone calls with duration < 60
For Receiver:
SELECT DISTINCT(name), phone_number, phone_calls.receiver, people.passport_number, people.license_plate FROM phone_calls
JOIN people ON people.phone_number = phone_calls.receiver
WHERE phone_calls.day="28" AND phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60;

Result:
+------------+----------------+----------------+-----------------+---------------+
|    name    |  phone_number  |    receiver    | passport_number | license_plate |
+------------+----------------+----------------+-----------------+---------------+
| Jack       | (996) 555-8899 | (996) 555-8899 | 9029462229      | 52R0Y8U       |
| Larry      | (892) 555-8872 | (892) 555-8872 | 2312901747      | O268ZZ0       |
| Robin      | (375) 555-8161 | (375) 555-8161 |                 | 4V16VO0       |
| Melissa    | (717) 555-1342 | (717) 555-1342 | 7834357192      |               |
| James      | (676) 555-6554 | (676) 555-6554 | 2438825627      | Q13SVG6       |
| Philip     | (725) 555-3243 | (725) 555-3243 | 3391710505      | GW362R6       |
| Jacqueline | (910) 555-3251 | (910) 555-3251 |                 | 43V0R5D       |
| Doris      | (066) 555-9701 | (066) 555-9701 | 7214083635      | M51FA04       |
| Anna       | (704) 555-2131 | (704) 555-2131 |                 |               |
+------------+----------------+----------------+-----------------+---------------+


For Caller:

SELECT DISTINCT(name), phone_number, phone_calls.caller, people.passport_number, people.license_plate FROM phone_calls
JOIN people ON people.phone_number = phone_calls.caller
WHERE phone_calls.day="28" AND phone_calls.month="07" AND phone_calls.year="2021"
AND phone_calls.duration < 60;

Result:

|  name   |  phone_number  |     caller     | passport_number | license_plate |
+---------+----------------+----------------+-----------------+---------------+
| Sofia   | (130) 555-0289 | (130) 555-0289 | 1695452385      | G412CB7       |
| Kelsey  | (499) 555-9472 | (499) 555-9472 | 8294398571      | 0NTHK55       |
| Bruce   | (367) 555-5533 | (367) 555-5533 | 5773159633      | 94KL13X       |
| Taylor  | (286) 555-6063 | (286) 555-6063 | 1988161715      | 1106N58       |
| Diana   | (770) 555-1861 | (770) 555-1861 | 3592750733      | 322W7JE       |
| Carina  | (031) 555-6622 | (031) 555-6622 | 9628244268      | Q12B3Z3       |
| Kenny   | (826) 555-1652 | (826) 555-1652 | 9878712108      | 30G67EN       |
| Benista | (338) 555-6650 | (338) 555-6650 | 9586786673      | 8X428L0       |



--Theory 1 The suspect is the caller or reciever and have a outbund flight in the morning
    --Extract the city code for Fiftyville
SELECT id, city FROM airports
WHERE city="Fiftyville";
--Result:
--| id |    city    |
--+----+------------+
--| 8  | Fiftyville |

    --Check if the caller has flight

SELECT people.name, flights.hour, flights.minute, flights.destination_airport_id, passengers.seat
FROM flights
JOIN passengers ON passengers.flight_id=flights.id
JOIN people ON people.passport_number=passengers.passport_number
WHERE people.name="Sofia" OR people.name="Kelsey" OR people.name="Bruce"
OR people.name="Taylor" OR people.name="Diana" OR people.name="Carina"
OR people.name="Kenny" OR people.name="Benista"
GROUP BY flights.hour, flights.minute;

--Results:
|  name   | hour | minute | destination_airport_id | seat |
+---------+------+--------+------------------------+------+
| Carina  | 7    | 37     | 3                      | 3A   |
| Sofia   | 8    | 20     | 4                      | 3B   |
| Diana   | 10   | 19     | 5                      | 6C   |
| Benista | 11   | 45     | 3                      | 7A   |

--Check if the receivers with passports have flights

SELECT people.name, flights.hour, flights.minute, flights.destination_airport_id, passengers.seat
FROM flights
JOIN passengers ON passengers.flight_id=flights.id
JOIN people ON people.passport_number=passengers.passport_number
WHERE people.name="Jack" OR people.name="Larry" OR people.name="Melissa"
OR people.name="James" OR people.name="Philip" OR people.name="Doris"
GROUP BY flights.hour, flights.minute;

Results:
|  name   | hour | minute | destination_airport_id | seat |
+---------+------+--------+------------------------+------+
| Larry   | 7    | 37     | 3                      | 5B   |
| Doris   | 8    | 20     | 4                      | 2A   |
| Philip  | 9    | 46     | 8                      | 4D   |

-- Check destination id
SELECT id, city FROM airports
WHERE airports.id="5";

--Analysing with the call + flight data the conclusion is:
    -- Suspects list: Carina, Sofia, Diana, Benista, Larry, Doris, Philip
    -- Potential complice: Robin, Jacqueline, Anna

--Check the list with ATM data

SELECT DISTINCT(atm_transactions.account_number), atm_transactions.amount,
people.id, people.name FROM atm_transactions
JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number
JOIN people ON people.id=bank_accounts.person_id
WHERE atm_transactions.day="28" AND atm_transactions.month="07" AND atm_transactions.year="2021"
AND atm_transactions.transaction_type="withdraw" AND people.name="Carina" OR people.name="Sofia"
OR people.name="Diana" OR people.name="Benista" OR people.name="Larry"
OR people.name="Doris" OR people.name="Philip" OR people.name="Robin"
OR people.name="Jacqueline" OR people.name="Anna";

Result:
+----------------+--------+--------+------------+
| account_number | amount |   id   |    name    |
+----------------+--------+--------+------------+
| 55322348       | 25     | 484375 | Anna       |
| 55322348       | 5      | 484375 | Anna       |
| 55322348       | 15     | 484375 | Anna       |
| 55322348       | 35     | 484375 | Anna       |
| 55322348       | 100    | 484375 | Anna       |
| 55322348       | 70     | 484375 | Anna       |
| 55322348       | 80     | 484375 | Anna       |
| 26013199       | 55     | 514354 | Diana      |
| 26013199       | 35     | 514354 | Diana      |
| 47746428       | 35     | 847116 | Philip     |
| 47746428       | 15     | 847116 | Philip     |
| 47746428       | 60     | 847116 | Philip     |
| 47746428       | 30     | 847116 | Philip     |
| 47746428       | 10     | 847116 | Philip     |
| 47746428       | 55     | 847116 | Philip     |
| 47746428       | 25     | 847116 | Philip     |
| 33528144       | 5      | 712712 | Jacqueline |
| 33528144       | 15     | 712712 | Jacqueline |
| 33528144       | 40     | 712712 | Jacqueline |
| 33528144       | 95     | 712712 | Jacqueline |
| 33528144       | 50     | 712712 | Jacqueline |
| 33528144       | 60     | 712712 | Jacqueline |
| 33528144       | 65     | 712712 | Jacqueline |
| 33528144       | 35     | 712712 | Jacqueline |
| 33528144       | 85     | 712712 | Jacqueline |
| 75571594       | 40     | 907148 | Carina     |
| 72161631       | 20     | 251693 | Larry      |
| 72161631       | 95     | 251693 | Larry      |
| 72161631       | 50     | 251693 | Larry      |
| 72161631       | 35     | 251693 | Larry      |
| 72161631       | 85     | 251693 | Larry      |
| 72161631       | 80     | 251693 | Larry      |
| 72161631       | 15     | 251693 | Larry      |
| 72161631       | 5      | 251693 | Larry      |
| 72161631       | 25     | 251693 | Larry      |
| 81061156       | 95     | 438727 | Benista    |
| 81061156       | 30     | 438727 | Benista    |
| 94751264       | 25     | 864400 | Robin      |
| 94751264       | 55     | 864400 | Robin      |
| 94751264       | 90     | 864400 | Robin      |
| 94751264       | 10     | 864400 | Robin      |
| 94751264       | 15     | 864400 | Robin      |
| 94751264       | 100    | 864400 | Robin      |
| 94751264       | 35     | 864400 | Robin      |
| 94751264       | 40     | 864400 | Robin      |
| 94751264       | 5      | 864400 | Robin      |
+----------------+--------+--------+------------+

--Analysing with the call + flight + ATM data the conclusion is:
    -- Suspects list: Carina, Diana, Benista, Larry, Philip
    -- Potential complice: Robin, Jacqueline, Anna

-- Check the list with parking data
SELECT bakery_security_logs.license_plate, bakery_security_logs.activity,
bakery_security_logs.hour, bakery_security_logs.minute, people.id, people.name
FROM bakery_security_logs
JOIN people ON people.license_plate = bakery_security_logs.license_plate
WHERE bakery_security_logs.day="28" AND bakery_security_logs.month="07"
AND bakery_security_logs.year="2021"
AND people.name="Carina" OR people.name="Diana"
OR people.name="Benista" OR people.name="Larry" OR people.name="Philip"
OR people.name="Robin" OR people.name="Jacqueline" OR people.name="Anna"
GROUP BY bakery_security_logs.hour;

Result:
+---------------+----------+------+--------+--------+------------+
| license_plate | activity | hour | minute |   id   |    name    |
+---------------+----------+------+--------+--------+------------+
| 322W7JE       | entrance | 8    | 36     | 514354 | Diana      |
| 322W7JE       | exit     | 10   | 23     | 514354 | Diana      |
| 43V0R5D       | entrance | 11   | 44     | 712712 | Jacqueline |
| 8X428L0       | entrance | 12   | 37     | 438727 | Benista    |
| 8X428L0       | exit     | 13   | 3      | 438727 | Benista    |
| GW362R6       | exit     | 18   | 27     | 847116 | Philip     |
+---------------+----------+------+--------+--------+------------+

--Suspects: Philip, Benista out of interested hours, Carina and Larry wasnt there
--Complice: Jacqueline left later, Anna wasnt there

--Analysing with the call + flight + ATM + Parking data the conclusion is:
    -- Suspects list: Diana | strong evidence
    -- Destination: Dallas
    -- Potential complice: Robin | No strong evidence


