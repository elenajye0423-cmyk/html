import os
import glob
import sys

# Set default encoding to utf-8 for stdout
import io
sys.stdout = io.TextIOWrapper(sys.stdout.detach(), encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.detach(), encoding='utf-8')

replacements = {
    '湲곗뾽?뚭컻': '기업소개',
    '湲곗뾽媛쒖슂': '기업개요',
    '?몄궗留?': '인사말',
    '?고쁺': '연혁',
    '議곗쭅??諛??낅Т遺꾩옣': '조직도 및 업무분장',
    '?몄쬆?꾪솴': '인증현황',
    '?곌뎄媛쒕컻(R&D)': '연구개발(R&D)',
    '李얠븘?ㅼ떆??湲?': '찾아오시는 길',
    '二쇱슂?쒗뭹': '주요제품',
    '湲됱닔 諛?媛€???쒖뒪??': '급수 및 가압 시스템',
    '諛곗닔 諛??ㅽ룓?? 泥섎━': '배수 및 오폐수 처리',
    '?곗뾽 諛??뱀닔 怨듭젙': '산업 및 특수 공정',
    '怨좉컼吏€??': '고객지원',
    '怨듭??ы빆': '공지사항',
    '?좎?愿?由?吏€移⑥꽌': '유지관리 지침서',
    '湲곗닠?먮즺??': '기술자료실',
    '?먯＜ 臾삳뒗 吏덈Ц': '자주 묻는 질문',
    '?띾낫?쇳꽣': '홍보센터',
    '?띾낫 ?곸긽': '홍보 영상',
    '釉뚮줈?덉뼱': '브로슈어',
    '移대뱶?댁뒪': '카드뉴스',
    'IR ?먮즺??': 'IR 자료실',
    '梨꾩슜': '채용',
    '?몄옱??': '인재상',
    '梨꾩슜怨듦퀬': '채용공고',
    '臾몄쓽': '문의',
    '(二?鍮꾩뿉?댄뀓': '(주)비에이텍',
    '源⑤걮?섍퀬 ?덉쟾??': '깨끗하고 안전한',
    '?쒖옉': '시작',
    '?뚰꽣?뚰봽': '워터펌프',
    '?ㅼ튂': '설치',
    '?섎━': '수리',
    '?꾨Ц湲곗뾽?낅땲??': '전문기업입니다.',
    '?뮛': '💧'
}

for filename in glob.glob('*.html'):
    try:
        with open(filename, 'rb') as f:
            content = f.read()
        
        # Try to decode as UTF-8
        try:
            text = content.decode('utf-8')
        except UnicodeDecodeError:
            text = content.decode('cp949', errors='ignore')
            
        for old, new in replacements.items():
            text = text.replace(old, new)
            
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(text)
        print(f'Fixed {filename}')
    except Exception as e:
        print(f'Error fixing {filename}: {e}')
