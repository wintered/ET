import os
import sys
import pandas as pd
if len(sys.argv) != 4:  
    print("Usage {} <csv-file1> <csv-file2> <colname>".format(sys.argv[0]))
    exit(2)

csv_file_1 = pd.read_csv(sys.argv[1])
csv_file_2 = pd.read_csv(sys.argv[2])
csv_file_1[sys.argv[-1]] = (csv_file_1[sys.argv[-1]] + csv_file_2[sys.argv[-1]]) / 2
csv_file_1.to_csv(os.path.basename(sys.argv[1])+".avg", index=False)
