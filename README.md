Networking scripts should check if ip_address_1 and ip_address_2 belogng to the same network or not
  - scripts can accepts first and second incoming parameters "ip_address_x", value in the formant x.x.x.x
  - the last paramerer is "network_mask", value in the format x.x.x.x or xx

Accounts scripts should create modified "accounts_new.csv"
  - file "accounts.csv" should be as agrument of the script
  - need to update column name
  - name format: first letter of name/surname uppercase and all ather letters lowercase
  - email format: firs letter from name and full surname, lowercase
  - equals email should contain location_id
  - result file should be created in the same directory where "accounts.csv"

Output scripts convert "output.txt" into valid "output.json" 
  - path to "output.txt" should be as argument to the script
  - the "output.json" should be located in the same directory as the "output.txt"


