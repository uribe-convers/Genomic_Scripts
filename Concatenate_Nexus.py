from Bio.Nexus import Nexus

file_list = ['temp1.nex', 'temp2.nex', 'temp3.nex', 'temp4.nex']
nexi =  [(fname, Nexus.Nexus(fname)) for fname in file_list]

combined = Nexus.combine(nexi)
combined.write_nexus_data(filename=open('All_Sequences_Concatenated.nex', 'w'))