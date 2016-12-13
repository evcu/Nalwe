#!/usr/bin/python

import json, sys, re
 
assert len(sys.argv)==3, "Plese provide the job-type and job-group-id"

jtype=str(sys.argv[1])
jid=str(sys.argv[2])
print ("Script name: %s" % str(sys.argv[0]))
print ("File name is jobs/logs/%s_%s" % (jtype,jid))

params=[]
lisa_ids=[]
results=[]

with open("jobs/logs/%s_%s" % (jtype,jid)) as f:
	for i,line in enumerate(f):
		print("%d: %s" % (i,line)) 
		try:
			if i==0:
				cpj = int(re.search('CALL_PER_JOB: (.+)', line).group(1))
				print(cpj)
			elif i==1:
				corpus = re.search('CORP: (.+)', line).group(1)
				print(cpj)
			elif i==2:
				max_time_per = re.search('VOC_FILE: (.+)', line).group(1)
				print(cpj)
			elif i==4:
				keys = line.split()
				print(keys)
			elif i>4:
				if (i-4)%(cpj+1)==0:
					#print("This is number: %d" % int(line))
					lisa_ids.append(int(line))
				else:
					#print(line.split())
					params.append(line.split())
		except LookupError:
			print "Invalid input file. Something is wrong with the file or the code"

for i,p in enumerate(params):
	temp_d={}
	temp_d['params']=dict(zip(keys,p)) #d for dictionary
	temp_d['job-id']=lisa_ids[i/cpj]
	with open("%s_%s_%d.sh.e%d" % (jtype,jid,i,temp_d['job-id'])) as f:
		next(f)
		train_d={}
		for l in f:
			a=l.split()
			train_d[a[0]]=a[1]

	with open("%s_%s_%d.sh.o%d" % (jtype,jid,i,temp_d['job-id'])) as f:
		next(f)
		train_d['voc-size']=next(f).split()[2]
		train_d['total-words']=next(f).split()[4]
		eval_d={}
		for j,l in enumerate(f):
			if l.startswith("ACCURACY"):
				tempstr=re.split('\(|\)|/',l)
				eval_d[test_name]=[tempstr[1],tempstr[2]]
			elif l.startswith("Questions seen/total:"):
				tempstr=re.split('\(|\)|/',l)
				eval_d['total']=[tempstr[2],tempstr[3]]
			elif l.startswith("Semantic accuracy:"):
				tempstr=re.split('\(|\)|/',l)
				eval_d['semantic']=[tempstr[1],tempstr[2]]
			elif l.startswith("Total accuracy:"):
				tempstr=re.split('\(|\)|/',l)
				eval_d['syntatic']=[tempstr[1],tempstr[2]]
			elif ((j-2)%2==0) and j<35:
				test_name=l[:-4]			
	temp_d['training']=train_d
	temp_d['eval']=eval_d
	results.append(temp_d)

with open('d.json','w') as fw:
	json.dump(results,fw)