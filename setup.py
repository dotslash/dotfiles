import sys
import os

bash_rc_loc = '.bashrc'
if sys.platform == 'darwin':
    bash_rc_loc = '.bash_profile'

file_path = os.path.realpath(__file__)
file_dir = '/'.join(file_path.split('/')[:-1])

mapping = {}
for src in os.listdir(file_dir + '/configs'):
    if src == 'vimrc':
        mapping[src] = '.vimrc'
    elif src == 'bashrc':
        mapping[src] = bash_rc_loc
    elif src.startswith('git'):
        mapping[src] = '.' + src
    else:
        print("Ignoring config:{}".format(src))

print("Config mappings to set: {}".format(mapping))
