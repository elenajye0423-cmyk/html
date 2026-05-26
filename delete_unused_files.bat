@echo off
chcp 65001 > nul
echo ==================================================
echo [비에이텍] 사용하지 않는 웹 자원 및 스크립트 삭제
echo ==================================================
echo.
echo 다음의 미사용 파일들이 안전하게 삭제됩니다:
echo - 구버전 및 미사용 HTML/JS 파일 (facilities.html, script.js 등)
echo - 구버전 및 미사용 이미지 에셋 (assets 내 구버전 펌프 이미지 등)
echo - 구버전 인증서 PDF 및 썸네일 폴더 (assets/certifications)
echo - 개발 및 백업용 유틸리티 스크립트
echo.
set /p confirm="정말로 삭제하시겠습니까? (Y/N): "
if /i "%confirm%" neq "Y" (
    echo.
    echo 삭제 작업을 취소했습니다.
    echo.
    pause
    exit /b
)

echo.
echo 삭제 작업을 진행합니다...
echo.

REM 1. 미사용 HTML / JS 파일 삭제
del /f /q "facilities.html" 2>nul
del /f /q "batech_water_campaign_v4.html" 2>nul
del /f /q "management-viewer.html" 2>nul
del /f /q "script.js" 2>nul
del /f /q "fix_nav.js" 2>nul
del /f /q "base64_nav.txt" 2>nul

REM 2. 루트 브로슈어 이미지 시안 삭제
del /f /q "brochure_inner.png" 2>nul
del /f /q "brochure_outer.png" 2>nul

REM 3. assets 폴더 내 구버전 펌프 이미지 및 설비 이미지 삭제
del /f /q "assets\booster_pump.png" 2>nul
del /f /q "assets\booster_pump_new.png" 2>nul
del /f /q "assets\mono_pump.png" 2>nul
del /f /q "assets\mono_pump_new.png" 2>nul
del /f /q "assets\sludge_pump.png" 2>nul
del /f /q "assets\sludge_pump_new.png" 2>nul
del /f /q "assets\submersible_pump.png" 2>nul
del /f /q "assets\submersible_pump_new.png" 2>nul
del /f /q "assets\volute_pump.png" 2>nul
del /f /q "assets\volute_pump_new.png" 2>nul
del /f /q "assets\metering_pump_new.png" 2>nul

del /f /q "assets\cnc_machine.png" 2>nul
del /f /q "assets\factory_exterior.png" 2>nul
del /f /q "assets\hoist_crane.png" 2>nul
del /f /q "assets\laser_alignment.png" 2>nul
del /f /q "assets\pump_test_rig.png" 2>nul
del /f /q "assets\vibration_analyzer.png" 2>nul

REM 4. assets/certifications 폴더 삭제 (하위 파일 및 폴더 전체 삭제)
rmdir /s /q "assets\certifications" 2>nul

REM 5. 개발자 유틸리티 스크립트 삭제
del /f /q "copy_brochure.ps1" 2>nul
del /f /q "copy_brochure.py" 2>nul
del /f /q "create_pdf.py" 2>nul
del /f /q "fix_encoding.py" 2>nul
del /f /q "fix_final.py" 2>nul
del /f /q "fix_final_v2.py" 2>nul
del /f /q "fix_mojibake.ps1" 2>nul
del /f /q "fix_nav_final.py" 2>nul
del /f /q "repair_all.py" 2>nul
del /f /q "repair_site.ps1" 2>nul
del /f /q "restore_korean.ps1" 2>nul
del /f /q "restore_manual.ps1" 2>nul
del /f /q "restore_nav.ps1" 2>nul
del /f /q "restore_nav.py" 2>nul
del /f /q "standardize_navbar.ps1" 2>nul
del /f /q "standardize_navbar_v2.ps1" 2>nul
del /f /q "standardize_navbar_v3.ps1" 2>nul
del /f /q "sync_music_v2.ps1" 2>nul

echo.
echo 모든 미사용 파일이 성공적으로 삭제 및 정리되었습니다!
echo 이 스크립트(delete_unused_files.bat) 자체도 이제 직접 삭제하셔도 무방합니다.
echo.
pause
