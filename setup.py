from pathlib import Path
from pprint import pformat
from typing import Dict, Iterable

import os
import sys
import time


DRY_RUN = len(sys.argv) > 1 and sys.argv[1] == "dry"

def backup_files(paths: Iterable[str]):
	now = time.time()
	for p_str in paths:
		p = Path(p_str).expanduser()
		if not p.exists():
			continue
		backup_p = Path(f'{p}_{now}')
		if not DRY_RUN:
			backup_p.write_text(p.read_text())
		print(f"Backed up {p} to {backup_p}")

def link_files(mapping: Dict[str, str]):
	for src, dst in mapping.items():
		dst_path = Path(dst).expanduser()
		# Remove the dst file and symlink the src. 
		if dst_path.exists():
			if not DRY_RUN:
				dst_path.unlink()
			print(f"Deleted dst_path")
		if not DRY_RUN:
			Path(src).symlink_to(str(dst_path))
		print(f"Synlinked {src} to {dst_path}")


def create_mapping() -> Dict[str, str]:
	bash_rc_loc = '~/.bashrc'
	if sys.platform == 'darwin':
	    bash_rc_loc = '~/.bash_profile'

	file_dir = Path(__file__).resolve().parent
	return {
		f'{file_dir}/vimrc': '~/.vimrc',
		f'{file_dir}/bashrc.sh': bash_rc_loc,
		f'{file_dir}/gitignore': '~/.gitignore',
		f'{file_dir}/gitconfig': '~/.gitconfig'
	}

if __name__ == '__main__':
	mapping = create_mapping()
	print(f"Config mappings to set: \n{pformat(mapping)}")
	backup_files(mapping.values())
	link_files(mapping)