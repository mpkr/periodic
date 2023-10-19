PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"
# require argument
if [[ ! $1 ]]
then
  echo Please provide an element as an argument.
else
    # if argument is number
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEM=$($PSQL "SELECT atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    elif [[ $1 =~ ^[A-Z][a-z]$|^[A-Z]$ ]]
      then
        ELEM=$($PSQL "SELECT atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
    else 
      ELEM=$($PSQL "SELECT atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
    fi
  #print result
    # if element is not found
    if [[ -z $ELEM ]]
    then
      echo "I could not find that element in the database."
    else
      # print result
      echo "$ELEM" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR MASS BAR MELT BAR BOIL BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
fi
