$utf8 = New-Object System.Text.UTF8Encoding $false

$archiveSrc = [IO.File]::ReadAllText("portal_archive.html", $utf8)

$badBlock = @'
        }], content: "<h3 style='margin-bottom: 15px;'>1. 문서 분석 요약 자동화</h3><p style='margin-bottom: 10px;'>방대한 양의 문서를 쉽고 빠르게 요약하여 업무 효율성을 극대화합니다.</p><p>자세한 내용은 상단 첨부파일을 확인해주세요.</p>", isSpecial: true },
                    { id: "a_vac", title: "연차/반차 휴가 신청서 양식 (2026 갱신)", date: "2026.01.10", views: 0, files: [{name: "연차_반차_휴가_신청서_양식.doc", url: "leave_form.html"}], content: "<h3 style='margin-bottom: 15px;'>2026년도 연차/반차 신청 안내</h3><p style='margin-bottom: 10px;'>새롭게 갱신된 2026년도 휴가 신청서 양식입니다.</p><p style='margin-bottom: 10px;'><strong>1. 신청기간:</strong> 사용 예정일 최소 3일 전까지 결재 완료 (기간 준수)</p><p style='margin-bottom: 10px;'><strong>2. 제출처:</strong> 소속 부서장 결재 후 총무부 서면 제출</p><br><p>상단의 첨부파일을 클릭하여 다운로드 받으신 후 작성 바랍니다.</p>" },
                    { id: "a_logo", title: "회사 공식 로고 원본 파일 (AI, PNG, JPG)", date: "2026.01.05", views: 0, files: [{name: "BATECH_Logo_AI.zip", url: "dummy_file.txt"}, {name: "BATECH_Logo_PNG_JPG.zip", url: "dummy_file.txt"}], content: "<p style='margin-bottom: 10px;'>비에이텍 공식 기업 로고 파일입니다.</p><p>대외 홍보물 및 공식 문서 작성 시 해당 로고를 사용해주시기 바랍니다.</p>" },
                    { id: "a_card", title: "법인카드 지출 결의서 양식 및 매뉴얼", date: "2025.12.20", views: 0, files: [{name: "지출결의서_양식_2026.xlsx", url: "dummy_file.txt"}, {name: "법인카드_사용_매뉴얼.pdf", url: "dummy_file.txt"}], content: "<p style='margin-bottom: 10px;'>법인카드 사용 후 제출해야 하는 지출 결의서 양식과 작성 매뉴얼입니다.</p><p>매월 5일까지 전월 사용분을 재무팀으로 제출해 주시기 바랍니다.</p>" }
                ];
                localStorage.setItem("batech_archive_v3", JSON.stringify(defaults));
            }
        }
'@

$archiveSrc = $archiveSrc.Replace($badBlock, '')

[IO.File]::WriteAllText("portal_archive.html", $archiveSrc, $utf8)

