#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n*** Welcome to the Salon ***\n"
echo -e "Which service would you like to book today?\n"

# show services
SERVICE_MENU() {
  # Get list of available services
    SERVICES=$($PSQL "SELECT service_id, name FROM services")  
    echo "$SERVICES" | sed 's/ |/)/g'
}  
  
SERVICE_MENU
# read service chosen
read SERVICE_ID_SELECTED

# if not a number
if [[ ! $SERVICE_ID_SELECTED =~ [0-6]+$ ]]
  then
    # send to list of services
    echo -e "\nSorry, that is not a valid service (please choose a number)."
    SERVICE_MENU
  else
    # Book the appointment
      # Ask for phone number
        echo -e "\nOkay, let's get you booked! \nWhat is your phone number?"
      # read phone number
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      #if customer doesn't exist
      if [[ -z $CUSTOMER_NAME ]]
        then
      # get new customer name
        echo -e "\nWhat is your name?"
      # read NAME
        read CUSTOMER_NAME
      # push data into customers table
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      fi
        # get customer id
         CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      # ask for appointment time
        echo -e "\nWhat time would you like an appointment?"
      # read appointment time
        read SERVICE_TIME
      # create appointment
        INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
        CUSTOMER_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
        echo -e "\nI have put you down for a $CUSTOMER_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
fi