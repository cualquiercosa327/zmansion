import os

last_line = ""
current_line = ""

buffer = []

for root, dirs, files in os.walk("../asm/"):
    for filename in files:
        with open(root + filename, "r") as f:
            for line in f.readlines():
                last_line = current_line;
                current_line = line.strip()
                
                # Check if this line is a label, and if the previous line as NOT a global.
                if current_line.startswith("lbl") and not last_line.startswith(".global"):
                    # Grab the label's address
                    addressStr = current_line.split("_")[1]
                    addressStr = addressStr.replace(':', '')
                    address = int(addressStr, 16)
                    
                    buffer.append(".global lbl_%08X\n" % address)
                    buffer.append("lbl_%08X:\n" % address)
                # If we're not doing anything, just pass the line into the buffer.
                else:
                    buffer.append(current_line + "\n")
                    
            with open(root + "\\global\\" + filename, "w+") as o:
                o.writelines(buffer)
                
            buffer.clear()
