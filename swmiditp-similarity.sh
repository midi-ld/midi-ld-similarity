#!/bin/bash

if [ $# -lt 2 ]
	  then
	    echo "Usage: swmiditp-similarity.sh <midi-file> <named-graph-uri>"
	    exit 0
	fi

# print bash results in csv
java -jar melodyshape-1.4.jar -q data/$1 -c data/ -a 2015-shapeh -k 10 | paste -s -d '\n' - > match.tsv

# call a python script to convert to rdf 
python midi_similarity.py $1 > match.nt

# curl send the .nt file to MIDI LOD Cloud
curl -s  -o /dev/null -X POST http://grlc.io/api/midi-ld/queries/insert_pattern -d"g=<$2>" -d"data=$(cat match.nt)"

# id send frbr links
curl -s  -o /dev/null -X POST http://grlc.io/api/midi-ld/queries/insert_pattern -d"g=<$2>" -d"data=$(cat links.nt)"
