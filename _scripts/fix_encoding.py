import os
import glob

replacements = {
    '湲곗닠?먮즺??': '기술자료실',
    '?먯＜ 臾삳뒗 吏덈Ц': '자주 묻는 질문',
    '?띾낫?쇳꽣': '홍보센터',
    '?띾낫': '홍보',
    '?몄옱??': '인재상',
    '梨꾩슜怨듦퀬': '채용공고',
    '梨꾩슜': '채용',
    '臾몄쓽': '문의',
    '湲곗뾽?뚭컻': '기업소개',
    '湲곗뾽媛쒖슂': '기업개요',
    '?몄궗留?': '인사말',
    '?곗쁺': '연혁',
    '議곗쭅??諛??낅Т遺꾩옣': '조직도 및 업무분장',
    '?몄쬆?ꪮ?귴솴': '인증현황',
    '?몄쬆?꾪솴': '인증현황',
    '?곌뎄媛쒕컻(R&D)': '연구개발(R&D)',
    '李얩븘?ㅼ떆??湲?': '찾아오시는 길',
    '二쇱슂?쒗뭹': '주요제품',
    '湲됱닔 諛?媛??묒떆?ㅽ뀥': '급수 및 가압 시스템',
    '諛곗닔 諛?遺??먯닔 泥섣━': '배수 및 오폐수 처리',
    '?곗뾽 諛??뱀닔 怨듭젙': '산업 및 특수 공정',
    '怨좉컼吏?썝': '고객지원',
    '怨듭??ы빆': '공지사항',
    '怨듭??Iterator': '공지사항',
    '?좎?愿?由?吏?쇱꽌': '유지관리 지침서',
    'IR ?먮즺??': 'IR 자료실'
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
