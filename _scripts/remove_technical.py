import os
import glob
import re

directory = '.'

patterns = [
    r'^\s*<li><a href="technical\.html">기술자료실</a></li>\s*\n?',
    r'^\s*<a href="technical\.html" class="sub-nav-link">기술자료실</a>\s*\n?',
    r'^\s*<a href="technical\.html" class="sub-nav-link active">기술자료실</a>\s*\n?'
]

count = 0

for file_path in glob.glob(os.path.join(directory, '*.html')) + glob.glob(os.path.join(directory, '*.txt')):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    for pattern in patterns:
        content = re.sub(pattern, '', content, flags=re.MULTILINE)
        
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {file_path}")
        count += 1

print(f"Total files updated: {count}")
