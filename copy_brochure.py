import shutil

src_outer = r'C:\Users\elena\.gemini\antigravity\brain\0ebe0439-714e-4d19-b187-43bec9d193fd\batech_brochure_outer_v2_1778738295096.png'
# 안쪽면(내부)은 이전 이미지 유지 — 별도 업데이트 시 경로 교체
src_inner = r'C:\Users\elena\.gemini\antigravity\brain\0ebe0439-714e-4d19-b187-43bec9d193fd\batech_brochure_inner_ko_1778734762099.png'

dst_outer = r'c:\Users\elena\OneDrive\바탕 화면\5월6일\홈페이지자료\Batech_Web\brochure_spread_outer.png'
dst_inner = r'c:\Users\elena\OneDrive\바탕 화면\5월6일\홈페이지자료\Batech_Web\brochure_spread_inner.png'

shutil.copy2(src_outer, dst_outer)
print(f'겉면 복사 완료: {dst_outer}')

shutil.copy2(src_inner, dst_inner)
print(f'안쪽면 복사 완료: {dst_inner}')

print('\n✅ 브로슈어 이미지 복사가 완료되었습니다!')
