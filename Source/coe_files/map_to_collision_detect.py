map_raw = "3555555555555555551,6888868888888788887,6855868555558785587,6888888888888888887,6185835185835187837,2086824085824087820,8886888885888887888,3182448444448440831,6788888888888888867,6783558318318551867,6786888688878887867,6786868688878787867,2086868244408787820,8888868888888788888,3184444485844444831,6788888885888888867,6084448444448444827,6888888888888888887,6831835585855183187,6867868885888786787,6820868444448782087,6888888888888888887,2444444444444444440"

lines = map_raw.split(',')

coll_detect_map = []
valid_move_space = ['8']

num_lines = len(lines)
for i in range(0, num_lines):
        tmp = [];
        line_len = len(lines[i])
        for char_num in range(0, line_len):
                if lines[i][char_num] in valid_move_space:
                        can_go_left = (lines[i][char_num - 1] in valid_move_space)
                        can_go_right = (lines[i][(char_num + 1) % line_len] in valid_move_space)
                        can_go_up = (lines[i - 1][char_num] in valid_move_space)
                        can_go_down = (lines[(i + 1) % num_lines][char_num] in valid_move_space)
                        code = int(can_go_down << 3) + int(can_go_up << 2) + int(can_go_right << 1) + can_go_left
                        tmp.append("%x" % (code))
                else:
                        tmp.append("f")
        coll_detect_map.append(''.join(tmp))
               
