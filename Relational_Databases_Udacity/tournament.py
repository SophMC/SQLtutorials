#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    
    ## Database connection
    pg = psycopg2.connect("dbname = tournament")
    
    # create a cursor
    c = pg.cursor()
    
    # execute a command
    c.execute("UPDATE players SET matches = 0, wins = 0")
    
    # commit the changes
    pg.commit()
    
    pg.close()


def deletePlayers():
    """Remove all the player records from the database."""
    
    ## Database connection
    pg = psycopg2.connect("dbname = tournament")
    
    # create a cursor
    c = pg.cursor()
    
    # execute a command
    c.execute("DELETE FROM players")
    
    # commit the changes
    pg.commit()
    
    pg.close()


def countPlayers():
    """Returns the number of players currently registered."""
    
    ## Database connection
    pg = psycopg2.connect("dbname = tournament")

    # create a cursor
    c = pg.cursor() 
    
    # execute a command
    c.execute("SELECT count(id) AS count FROM players")  
   
    # gets the output of the execute statment
    counts = [int(row[0]) for row in c.fetchall()]
    
    pg.close()
    
    print counts[0]
    return counts[0]
   

def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
     ## Database connection
    pg = psycopg2.connect("dbname = tournament")

    # create a cursor
    c = pg.cursor()
    
     # execute a command
    c.execute("INSERT INTO players(name, wins, matches) VALUES \
              (%s,0,0)",(name,))  
    
    # commit the changes
    pg.commit()
   
    pg.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    
    ## Database connection
    pg = psycopg2.connect("dbname = tournament")
    
    # create a cursor
    c = pg.cursor()
    
    # execute a command
    c.execute("SELECT * from players ORDER BY wins DESC")
    
    standings = [row for row in c.fetchall()]
    
    pg.close()
    
    return standings
   

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    ## Database connection
    pg = psycopg2.connect("dbname = tournament")
    
    ## create a cursor
    c = pg.cursor()
    
       
    # update the players table with their wins, matches.
    c.execute("""UPDATE players SET wins=wins+1, matches=matches+1
      WHERE id = %s """,(winner,))
    
    c.execute("UPDATE players SET matches=matches+1 WHERE id = %s",(loser,))
      
    # commit the changes
    pg.commit()
   
    pg.close()
    
  
def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    
    ## Database connection
    pg = psycopg2.connect("dbname = tournament")
    
    ## create a cursor
    c = pg.cursor()
    
    ## Execute a command
    c.execute("""SELECT tab1.id, tab1.name, tab2.id, tab2.name FROM (SELECT *
              FROM players) AS tab1 JOIN (SELECT * FROM players) AS tab2 ON 
              tab1.matches = tab2.matches AND tab1.wins = tab2.wins AND tab1.id 
              != tab2.id ORDER BY tab1.matches DESC LIMIT 4""")
    
    # Get the results from the sql query and store in a tuple
    pairings = [row for row in c.fetchall()]
   
    pg.close()
    
    return pairings


