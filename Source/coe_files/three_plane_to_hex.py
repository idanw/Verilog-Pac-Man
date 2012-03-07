f = open("map_sprite_blue.coe", "r")
lines = f.readlines()

blue = []

for line in lines:
    if(len(line) == 18):
        if(line[16] == ','):
            blue.append(line[0:16])
f.close()
f = open("map_sprite_red.coe", "r")
lines = f.readlines()

red = []

for line in lines:
    if(len(line) == 18):
        if(line[16] == ','):
            red.append(line[0:16])
f.close()
f = open("map_sprite_green.coe", "r")
lines = f.readlines()

green = []

for line in lines:
    if(len(line) == 18):
        if(line[16] == ','):
            green.append(line[0:16])
f.close()
output_lines = []
for i in range(0, len(red)):
    asdf = []
    for j in range(0,16):
        asdf.append("%x" % ((int(red[i][j]) << 2) + (int(green[i][j]) << 1) + int(blue[i][j])))
    output_lines.append(''.join(asdf) + ',\n')
    
f = open("map_sprite_combined_hex.coe", "w")
f.writelines(output_lines)
f.flush()
f.close()
