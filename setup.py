from pathlib import Path
from pprint import pformat
from typing import Dict, Iterable

import os
import sys
import time


DRY_RUN = len(sys.argv) > 1 and sys.argv[1] == "dry"

# Backs up the files and returns a script string to undo the changes 
# in this script 
def backup_files(paths: Iterable[str]) -> str:
  now = time.time()
  undo_sript_lines = []
  for p_str in paths:
    p = Path(p_str).expanduser()
    if not p.exists():
      undo_sript_lines.append(f'rm {p}')
      continue
    backup_p = Path(f'{p}_{now}')
    if not DRY_RUN:
      backup_p.write_text(p.read_text())
    print(f"Backed up {p} to {backup_p}")
    undo_sript_lines.append(f'rsync {backup_p} {p}')
  return ' && '.join(undo_sript_lines)

def link_files(mapping: Dict[str, str]):
  for src, dst in mapping.items():
    dst_path = Path(dst).expanduser()
    # Remove the dst file and symlink the src. 
    if dst_path.exists():
      if not DRY_RUN:
        dst_path.unlink()
    if not DRY_RUN:
      Path(dst_path).symlink_to(str(src))
    print(f"Synlinked {dst_path} to {src}")



def create_mapping() -> Dict[str, str]:
  bash_rc_loc = '~/.bashrc'
  if sys.platform == 'darwin':
      bash_rc_loc = '~/.bash_profile'
  file_dir = Path(__file__).resolve().parent
  ret = {
    f'{file_dir}/vimrc': '~/.vimrc',
    f'{file_dir}/bashrc.sh': bash_rc_loc,
    f'{file_dir}/gitignore': '~/.gitignore',
    f'{file_dir}/gitconfig': '~/.gitconfig'
  }
  custom_bashrc = f"{file_dir}/custom_bashrc.sh"
  if Path(custom_bashrc).exists():
  	ret[custom_bashrc] = '~/.custom_bashrc.sh'
  return ret


if __name__ == '__main__':
  mapping = create_mapping()
  print(f"Config mappings to set: \n{pformat(mapping)}")
  undo_script = backup_files(mapping.values())
  link_files(mapping)
  print("====================")
  print("If you dont like this outcome, run the following in bash to undo:")
  print(undo_script)
  print("====================")