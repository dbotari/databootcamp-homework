import os
import csv

election_path = os.path.join('Resources','election_data.csv')

votes = 0

with open(election_path, 'r') as csvfile:
    csv_reader = csv.reader(csvfile, delimiter = ",")
    next (csv_reader)

    #read csv into dictionary and count votes cast
    d={}
    for row in csv_reader:
        d[row[0]]=row[2]
        votes += 1

candidate_list=list(d.values())

freq = {}
for items in candidate_list:
    if (items in freq):
        freq[items] += 1
    else:
        freq[items] = 1

print(f"Election Results:")
print(f"----------------------------")
print(f"Total Votes: {votes}")
print(f"----------------------------")
for key, value in freq.items():
    print("{} : {}% ({})".format(key, round(((value/votes)*100),5), value)) 
print(f"----------------------------")
#for key, value in freq.items():

print("Winner: {}".format(max(freq.items(),key= lambda x :x[1])))

election_results = os.path.join('Output','election_results.csv')

#Open output file
with open(election_results, 'w', newline ="") as outfile:
    csvwriter = csv.writer(outfile)
    # Write the row content
    csvwriter.writerow(['Election Results:'])
    csvwriter.writerow(['-----------------'])
    csvwriter.writerow(['Total Votes:', votes])
    csvwriter.writerow(['-----------------'])
    for key, value in freq.items():
        csvwriter.writerow(['{} : {}% ({})'.format(key, round(((value/votes)*100),5), value)]) 
    csvwriter.writerow(['-----------------'])   
    csvwriter.writerow(['Winner: {}'.format(max(freq.items(),key= lambda x: x[1]))])
