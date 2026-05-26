import os
import re

dir_path = r"c:\Users\elena\OneDrive\바탕 화면\html-main\html-main"

group_a = {
    "intro.html": "기업개요",
    "greetings.html": "인사말",
    "sales_history.html": "연혁",
    "organization.html": "조직도 및 업무분장",
    "portfolio.html": "납품 실적",
    "map.html": "찾아오시는 길"
}

group_b = {
    "rd.html": "연구개발(R&D)",
    "certifications.html": "인증현황",
    "facilities.html": "주요시설"
}

def generate_subnav(group_dict, current_file):
    html = '    <nav class="sub-nav">\n        <div class="sub-nav-container">\n'
    for filename, title in group_dict.items():
        active_class = ' active' if filename == current_file else ''
        html += f'            <a href="{filename}" class="sub-nav-link{active_class}">{title}</a>\n'
    html += '        </div>\n    </nav>'
    return html

def process_files(group_dict):
    for filename in group_dict.keys():
        filepath = os.path.join(dir_path, filename)
        if not os.path.exists(filepath):
            continue
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        new_subnav = generate_subnav(group_dict, filename)
        # Replace existing sub-nav
        new_content = re.sub(r'(?s)    <nav class="sub-nav">.*?</nav>', new_subnav, content)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filename}")

process_files(group_a)
process_files(group_b)
