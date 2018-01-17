#!/bin/bash

#--------------------------------------------------------------------#
# Export all mongodb collections of a database in csvs format 
# File name    : mongo-to-csv.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Thu Jan 18 00:54:21 IST 2018
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for getting collections of mongodb database in csv format.
# Important    : 1. Change / Add / Fill your detail in "Fill in your details here" block.
#                2. Ensure mongodb is installed and configured properly.
#                3. Script is by default assuming no authentication, localhost as host and default 27017
#--------------------------------------------------------------------#


################# Fill in your details here ################# 

# dbname=DBNAME
dbname=gstudio-mongodb                                           # Example for setting the value                           
# user=USERNAME
# pass=PASSWORD
# host=HOSTNAME:PORT

#############################################################


################# Start of code ################# 

# Set IFS to ","
OIFS=$IFS;
IFS=",";

# Function to print a line/separator
function line()
{
    echo "--------------------------------$1-------------------------------------";
}

# First get all collections in the database
# collections=`mongo "$host/$dbname" -u $user -p $pass --eval "rs.slaveOk();db.getCollectionNames();"`;           # with auth
collections=`mongo $dbname --eval "rs.slaveOk();db.getCollectionNames();"`;                                       # without auth

# Remove "[" and "]" from string
collections="${collections#*[}";
collections="${collections%*]}";

# Removing all spaces, tabs, newlines, double qoutes("), etc from a variable - https://unix.stackexchange.com/questions/32569/removing-all-spaces-tabs-newlines-etc-from-a-variable
collectionArray=($(echo "${collections%*]}" | tr -d '\040\011\012\015\"'));
#echo "collectionArray=${collectionArray[@]}";                   # For testing purpose

# for each collection
for ((i=0; i<${#collectionArray[@]}; ++i));
do
    # echo 'exporting collection' ${collectionArray[$i]}        # For testing purpose
    # get comma separated list of keys. do this by peeking into the first document in the collection and get his set of keys
    # keys=`mongo "$host/$dbname" -u $user -p $pass --eval "rs.slaveOk();var keys = []; for(var key in db.${collectionArray[$i]}.find().sort({_id: -1}).limit(1)[0]) { keys.push(key); }; keys;" --quiet`;             # with auth
    keys=`mongo "$dbname" --eval "rs.slaveOk();var keys = []; for(var key in db.${collectionArray[$i]}.find().sort({_id: -1}).limit(1)[0]) { keys.push(key); }; keys;" --quiet`;                                       # without auth

    # Remove "[" and "]" from string
    keys="${keys#*[}";
    keys="${keys%*]}";

    # Removing all spaces, tabs, newlines, double qoutes("), etc from a variable - (ref:- https://unix.stackexchange.com/questions/32569/removing-all-spaces-tabs-newlines-etc-from-a-variable)
    keys=$(echo "${keys%*]}" | tr -d '\040\011\012\015\"');
    #echo "keysArray:$keys:";                                   # For testing purpose

    echo -e "";
    # Print start line
    line "Start export collection $i";
    echo -e "";
    
    # Print details - DB name,Full collection array,Current collection name, csv Filename, keys/fields 
    echo "DB name : $dbname";
    echo "Full collection array : ${collectionArray[@]}";
    echo "Current collection name : ${collectionArray[$i]}";
    echo "csv Filename : $dbname.${collectionArray[$i]}.csv";
    echo "Keys/fields : ${keys}";

    echo -e "";
    # Print line
    line "export output";
    echo -e "";
    
    # now use mongoexport with the set of keys to export the collection to csv
    # mongoexport --host $host -u $user -p $pass -d $dbname -c ${collectionArray[$i]} --fields "$keys" --csv --out $dbname.${collectionArray[$i]}.csv;                     # with auth
    echo "mongoexport --db $dbname --collection ${collectionArray[$i]} --type=csv --fields ${keys}  --out $dbname.${collectionArray[$i]}.csv;"                             # just for printing
    mongoexport --db $dbname --collection ${collectionArray[$i]} --type=csv --fields "${keys}"  --out $dbname.${collectionArray[$i]}.csv;                                  # without auth

    echo -e "";
    # Print end line
    line "End export collection $i";
    echo -e "\n\n";
done

# Set IFS to Old IFS (OIFS)
IFS=$OIFS;

################# End of code ################# 


################# Expected output ################# 

# root@test:/root/# bash mongo-to-csv.sh
#
# --------------------------------Start export collection 0------------------------------------
#
# DB name : gstudio-mongodb
# Full collection array : Benchmarks Benchmarks_keys Counters Counters_keys Filehives Filehives_keys Filehives_keys_keys Nodes Nodes_keys Triples _keys analytics_collection fs.chunks fs.files
# Current collection name : Filehives_keys_keys
# csv Filename : gstudio-mongodb.Filehives_keys_keys.csv
# Keys/fields : _id,value
#
# --------------------------------export output-------------------------------------
#
# mongoexport --db gstudio-mongodb --collection Filehives_keys_keys --type=csv --fields _id,value  --out gstudio-mongodb.Filehives_keys_keys.csv;
# 2018-01-18T00:50:52.054+0530connected to: localhost
# 2018-01-18T00:50:52.055+0530exported 2 records
#
# --------------------------------End export collection 0-------------------------------------



# --------------------------------Start export collection 1-------------------------------------
#
# DB name : gstudio-mongodb
# Full collection array : Benchmarks Benchmarks_keys Counters Counters_keys Filehives Filehives_keys Filehives_keys_keys Nodes Nodes_keys Triples _keys analytics_collection fs.chunks fs.files
# Current collection name : Nodes
# csv Filename : gstudio-mongodb.Nodes.csv
# Keys/fields : _id,_type,doc_id,required_for
#
# --------------------------------export output-------------------------------------
#
# mongoexport --db gstudio-mongodb --collection Nodes --type=csv --fields _id,_type,doc_id,required_for  --out gstudio-mongodb.Nodes.csv;
# 2018-01-18T00:50:52.155+0530connected to: localhost
# 2018-01-18T00:50:53.156+0530[########................]  gstudio-mongodb.Nodes  48000/136505  (35.2%)
# 2018-01-18T00:50:54.156+0530[################........]  gstudio-mongodb.Nodes  96000/136505  (70.3%)
# 2018-01-18T00:50:54.897+0530[########################]  gstudio-mongodb.Nodes  136505/136505  (100.0%)
# 2018-01-18T00:50:54.897+0530exported 136505 records
#
# --------------------------------End export collection 1-------------------------------------

################################################### 