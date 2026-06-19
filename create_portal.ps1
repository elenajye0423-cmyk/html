$utf8 = New-Object System.Text.UTF8Encoding $false
$src = [IO.File]::ReadAllText("index.html", $utf8)

$dashboardContent = '
    <style>
        .portal-layout {
            padding: 100px 0;
            background-color: #f8fafc;
            min-height: 100vh;
        }
        .portal-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        .portal-header h1 {
            font-size: 2.5rem;
            color: #0f172a;
            margin-bottom: 0.5rem;
            font-weight: 800;
        }
        .portal-header p {
            color: #64748b;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }
        .dashboard-grid.bottom {
            grid-template-columns: 1fr 1fr 1fr;
            margin-top: 2rem;
        }
        .dashboard-grid.full {
            grid-template-columns: 1fr;
            margin-top: 2rem;
        }
        .panel {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            padding: 1.5rem;
            border-top: 4px solid var(--primary-color);
        }
        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 0.8rem;
        }
        .panel-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-sm {
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            font-size: 0.85rem;
            cursor: pointer;
            border: none;
            background: #e2e8f0;
            color: #475569;
            font-weight: 600;
            transition: 0.2s;
        }
        .btn-sm.primary {
            background: var(--primary-color);
            color: #fff;
        }
        .btn-sm:hover { filter: brightness(0.95); }
        
        /* List Styles */
        .data-list { list-style: none; padding: 0; margin: 0; }
        .data-list li {
            padding: 0.8rem 0;
            border-bottom: 1px dashed #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .data-list li:last-child { border-bottom: none; }
        .data-list a { color: #334155; font-weight: 500; transition: 0.2s; text-decoration: none; }
        .data-list a:hover { color: var(--primary-color); }
        .data-list .meta { font-size: 0.85rem; color: #94a3b8; }
        .data-list .badge {
            background: #fef08a; color: #854d0e; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem; font-weight: 700;
        }
        .badge.new { background: #fecaca; color: #991b1b; }

        /* Calendar Mock */
        .cal-grid {
            display: grid; grid-template-columns: repeat(7, 1fr); gap: 2px; background: #e2e8f0; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden;
        }
        .cal-header { background: #f8fafc; font-weight: 700; font-size: 0.8rem; text-align: center; padding: 0.5rem; color: #64748b; }
        .cal-day { background: #fff; height: 60px; padding: 0.3rem; font-size: 0.85rem; color: #334155; position: relative; }
        .cal-day.empty { background: #f8fafc; color: #cbd5e1; }
        .cal-event {
            background: #dbeafe; color: #1e40af; font-size: 0.7rem; padding: 0.15rem 0.3rem; border-radius: 3px; margin-top: 0.2rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; cursor: pointer;
        }
        .cal-event.meeting { background: #fce7f3; color: #9d174d; }

        /* Table Styles for Inquiry */
        .data-table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }
        .data-table th, .data-table td { padding: 0.8rem; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .data-table th { background: #f8fafc; font-weight: 600; color: #475569; }
        .status-wait { color: #ea580c; font-weight: 600; background: #ffedd5; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; }
        .status-done { color: #16a34a; font-weight: 600; background: #dcfce7; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; }
        
        @media (max-width: 900px) {
            .dashboard-grid, .dashboard-grid.bottom { grid-template-columns: 1fr; }
        }
    </style>
    
    <div class="portal-layout">
        <div class="portal-header fade-in-up">
            <h1>사내 포털 대시보드</h1>
            <p>비에이텍 임직원 전용 업무 공간입니다. (보안 레벨: 내부용)</p>
        </div>

        <div class="dashboard-grid fade-in-up delay-1">
            <!-- 사내 공지사항 -->
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📢 사내 공지사항</div>
                    <button class="btn-sm">전체보기</button>
                </div>
                <ul class="data-list">
                    <li><a href="#"><span class="badge new">필독</span> 2026년 하반기 전사 워크숍 일정 안내</a> <span class="meta">2026.06.01</span></li>
                    <li><a href="#">급수 펌프 신제품(BT-900) 메뉴얼 배포</a> <span class="meta">2026.05.28</span></li>
                    <li><a href="#">6월 임직원 생일자 축하 안내</a> <span class="meta">2026.05.25</span></li>
                    <li><a href="#">사내 보안 점검 및 비밀번호 변경 캠페인</a> <span class="meta">2026.05.20</span></li>
                    <li><a href="#">법정 의무 교육 이수 기한 안내</a> <span class="meta">2026.05.15</span></li>
                </ul>
            </div>

            <!-- 사내 캘린더 -->
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📅 사내 일정 (6월)</div>
                    <button class="btn-sm" onclick="alert(\`일정 등록 팝업창이 열립니다.\`);">일정 등록</button>
                </div>
                <div class="cal-grid">
                    <div class="cal-header">일</div><div class="cal-header">월</div><div class="cal-header">화</div><div class="cal-header">수</div><div class="cal-header">목</div><div class="cal-header">금</div><div class="cal-header">토</div>
                    <div class="cal-day empty">31</div>
                    <div class="cal-day">1 <div class="cal-event" onclick="alert(\`상세 일정: 정례조회\n장소: 대회의실\`);">정례조회</div></div>
                    <div class="cal-day">2</div>
                    <div class="cal-day">3</div>
                    <div class="cal-day">4 <div class="cal-event meeting" onclick="alert(\`상세 일정: 영업팀 회의\n장소: 제1회의실\`);">영업팀 회의</div></div>
                    <div class="cal-day">5</div>
                    <div class="cal-day">6</div>
                    <div class="cal-day">7</div>
                    <div class="cal-day">8</div>
                    <div class="cal-day">9</div>
                    <div class="cal-day">10</div>
                    <div class="cal-day">11 <div class="cal-event meeting" onclick="alert(\`상세 일정: 기술팀 세미나\n장소: 연구소\`);">기술팀 세미나</div></div>
                    <div class="cal-day">12 <div class="cal-event" onclick="alert(\`상세 일정: 전사 워크숍 출발\n장소: 춘천\`);">워크숍 출발</div></div>
                    <div class="cal-day">13</div>
                </div>
                <p style="text-align: right; font-size: 0.8rem; color: #94a3b8; margin-top: 0.5rem; margin-bottom: 0;">※ 상세 일정은 클릭하여 확인하세요.</p>
            </div>
        </div>

        <div class="dashboard-grid bottom fade-in-up delay-2">
            <!-- 익명 게시판 -->
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">🗣️ 소통의 장 (익명)</div>
                    <button class="btn-sm primary" onclick="alert(\`익명 게시물 작성 창이 열립니다.\`);">글쓰기</button>
                </div>
                <ul class="data-list">
                    <li><a href="#" onclick="alert(\`게시물 상세 내용을 조회합니다.\`);">휴게실 커피 머신 원두 종류 좀...</a> <span class="meta">익명</span></li>
                    <li><a href="#" onclick="alert(\`게시물 상세 내용을 조회합니다.\`);">회식 장소 추천 받습니다!</a> <span class="meta">익명</span></li>
                    <li><a href="#" onclick="alert(\`게시물 상세 내용을 조회합니다.\`);">요즘 날씨가 너무 덥네요 다들 화이팅</a> <span class="meta">익명</span></li>
                    <li><a href="#" onclick="alert(\`게시물 상세 내용을 조회합니다.\`);">이번 워크숍 장소 너무 기대됩니다ㅎㅎ</a> <span class="meta">익명</span></li>
                </ul>
            </div>

            <!-- 자료실 -->
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">📂 사내 자료실</div>
                    <button class="btn-sm" onclick="alert(\`파일 업로드 창이 열립니다.\`);">자료 업로드</button>
                </div>
                <ul class="data-list">
                    <li><a href="#" onclick="alert(\`파일이 다운로드 됩니다.\`);">📄 연차/반차 휴가 신청서 양식</a> <span class="meta">인사팀</span></li>
                    <li><a href="#" onclick="alert(\`파일이 다운로드 됩니다.\`);">📄 회사 공식 로고 파일 (AI, PNG)</a> <span class="meta">홍보팀</span></li>
                    <li><a href="#" onclick="alert(\`파일이 다운로드 됩니다.\`);">📄 법인카드 지출 결의서 양식</a> <span class="meta">재무팀</span></li>
                    <li><a href="#" onclick="alert(\`파일이 다운로드 됩니다.\`);">📄 2026년도 취업규칙 개정안</a> <span class="meta">인사팀</span></li>
                </ul>
            </div>

            <!-- 미결재/알림 -->
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">🔔 나의 알림 및 결재</div>
                </div>
                <ul class="data-list">
                    <li><a href="#">[결재 대기] 6월 기술팀 비품 구매 기안</a> <span class="meta" style="color: #ea580c; font-weight: 700;">1건</span></li>
                    <li><a href="#">[결재 대기] 외근 교통비 청구의 건</a> <span class="meta" style="color: #ea580c; font-weight: 700;">1건</span></li>
                    <li><a href="#">[수신함] 안전보건교육 이수증 제출 요청</a> <span class="meta">2시간 전</span></li>
                    <li><a href="#">[수신함] 금주 금요일 구내식당 메뉴 안내</a> <span class="meta">1일 전</span></li>
                </ul>
            </div>
        </div>

        <div class="dashboard-grid full fade-in-up delay-3">
            <!-- 문의 내역 관리 -->
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">✉️ 고객 문의 관리 (CS Dashboard)</div>
                    <button class="btn-sm" onclick="alert(\`엑셀 파일로 문의 내역이 다운로드 됩니다.\`);">엑셀 다운로드</button>
                </div>
                <div style="overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>상태</th>
                                <th>접수일</th>
                                <th>고객명/회사명</th>
                                <th>문의 유형</th>
                                <th>제목</th>
                                <th>담당자</th>
                                <th>작업</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="status-wait">답변 대기</span></td>
                                <td>2026-06-08 14:20</td>
                                <td>김*민 (한국건설)</td>
                                <td>제품 문의</td>
                                <td>부스터 펌프 대용량 모델 견적 요청드립니다.</td>
                                <td>-</td>
                                <td><button class="btn-sm primary" onclick="alert(\`고객에게 직접 메일로 답글을 작성할 수 있는 모달창이 열립니다.\`);">답글 작성</button></td>
                            </tr>
                            <tr>
                                <td><span class="status-wait">답변 대기</span></td>
                                <td>2026-06-08 11:05</td>
                                <td>박*수 (강원환경)</td>
                                <td>A/S 접수</td>
                                <td>수중펌프 작동 이상으로 A/S 신청합니다.</td>
                                <td>-</td>
                                <td><button class="btn-sm primary" onclick="alert(\`고객에게 직접 메일로 답글을 작성할 수 있는 모달창이 열립니다.\`);">답글 작성</button></td>
                            </tr>
                            <tr>
                                <td><span class="status-done">처리 완료</span></td>
                                <td>2026-06-07 16:40</td>
                                <td>이*영 (개인)</td>
                                <td>기타 문의</td>
                                <td>펌프 소음 관련 매뉴얼 문의</td>
                                <td>기술지원팀</td>
                                <td><button class="btn-sm" onclick="alert(\`완료된 문의의 상세 답변 내역을 조회합니다.\`);">내역 보기</button></td>
                            </tr>
                            <tr>
                                <td><span class="status-done">처리 완료</span></td>
                                <td>2026-06-06 09:15</td>
                                <td>최*호 (서울엔지니어링)</td>
                                <td>제품 문의</td>
                                <td>산업용 정량 펌프 카탈로그 송부 요청</td>
                                <td>영업1팀</td>
                                <td><button class="btn-sm" onclick="alert(\`완료된 문의의 상세 답변 내역을 조회합니다.\`);">내역 보기</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
'

# Replace everything between </nav> and <footer>
$baseSrc = $src -replace '(?s)(</nav>).*?(<footer>)', "`$1`r`n$dashboardContent`r`n`$2"

# Fix Title
$baseSrc = $baseSrc -replace '<title>.*?\| \(주\)비에이텍</title>', '<title>사내 포털 | (주)비에이텍</title>'
$baseSrc = $baseSrc -replace '<title>비에이텍 \(B.A. TECH\) - 워터펌프 시스템 전문 기업</title>', '<title>사내 포털 | (주)비에이텍</title>'

[IO.File]::WriteAllText("portal.html", $baseSrc, $utf8)

