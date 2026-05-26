document.addEventListener('DOMContentLoaded', () => {
    const librarySection = document.getElementById('library-section');
    const viewerSection = document.getElementById('viewer-section');
    const bookContainer = document.getElementById('book');
    const loading = document.getElementById('loading');
    const loadingText = document.getElementById('loading-text');
    const closeViewerBtn = document.getElementById('close-viewer');
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    const pageInfo = document.getElementById('page-info');

    let pageFlip = null;
    let pdfDoc = null;

    const manuals = [
        { name: '부스터펌프', pdf: 'assets/manuals/부스터펌프 유지관리지침서.pdf', img: 'assets/booster_pump_pro.png' },
        { name: '수중펌프', pdf: 'assets/manuals/수중펌프 유지관리지침서.pdf', img: 'assets/submersible_pump_pro.png' },
        { name: '슬러지펌프', pdf: 'assets/manuals/슬러지펌프 유지관리지침서.pdf', img: 'assets/sludge_pump_pro.png' },
        { name: '일축나사식 모노펌프', pdf: 'assets/manuals/일축나사식 모노펌프 유지관리지침서.pdf', img: 'assets/mono_pump_pro.png' },
        { name: '편흡입볼류트펌프', pdf: 'assets/manuals/편흡입볼류트펌프 유지관리지침서.pdf', img: 'assets/volute_pump_pro.png' },
        { name: '정량펌프', pdf: 'assets/manuals/정량펌프 유지관리지침서.pdf', img: 'assets/metering_pump_pro.png' }
    ];

    // Initialize Library Grid
    function initLibrary() {
        if (!librarySection) return;
        librarySection.innerHTML = '';
        manuals.forEach(manual => {
            const card = document.createElement('div');
            card.className = 'manual-card';
            card.innerHTML = `
                <img src="${manual.img}" alt="${manual.name}">
                <h3>${manual.name}</h3>
                <span class="read-btn">지침서 읽기</span>
            `;
            card.onclick = () => openViewer(manual);
            librarySection.appendChild(card);
        });
    }

    async function openViewer(manual) {
        if (librarySection) librarySection.style.display = 'none';
        if (viewerSection) viewerSection.style.display = 'block';
        window.scrollTo({ top: 0, behavior: 'smooth' });
        await loadPdf(manual.pdf, manual.name);
    }

    if (closeViewerBtn) {
        closeViewerBtn.onclick = () => {
            viewerSection.style.display = 'none';
            librarySection.style.display = 'grid';
            if (pageFlip) pageFlip.destroy();
            bookContainer.innerHTML = '';
        };
    }

    async function loadPdf(url, manualName) {
        loading.style.display = 'block';
        bookContainer.innerHTML = '';
        
        try {
            const loadingTask = pdfjsLib.getDocument(url);
            pdfDoc = await loadingTask.promise;
            
            const totalPages = pdfDoc.numPages;
            loadingText.textContent = `Rendering ${totalPages} pages...`;
            
            const htmlPages = [];

            // 1. Add Hard Front Cover
            htmlPages.push(`
                <div class="page hard" data-density="hard">
                    <div class="page-content" style="background:#1e293b; display:flex; flex-direction:column; align-items:center; justify-content:center; color:white; padding: 2rem; text-align:center; height:100%;">
                        <h2 style="font-size:1.8rem; margin-bottom:1rem; color: #60a5fa;">${manualName}</h2>
                        <h3 style="font-size:1.2rem; opacity:0.8;">유지관리지침서</h3>
                        <p style="margin-top:2rem; font-size:0.9rem; opacity:0.6;">(주)비에이텍</p>
                    </div>
                </div>
                <div class="page hard" data-density="hard">
                    <div class="page-content" style="background-color:#f8fafc; height:100%;"></div>
                </div>
            `);

            // 2. Render PDF Pages
            for (let i = 1; i <= totalPages; i++) {
                const page = await pdfDoc.getPage(i);
                const viewport = page.getViewport({ scale: 2 });
                
                const canvas = document.createElement('canvas');
                const context = canvas.getContext('2d');
                canvas.height = viewport.height;
                canvas.width = viewport.width;
                
                await page.render({ canvasContext: context, viewport: viewport }).promise;
                
                const imgData = canvas.toDataURL('image/jpeg', 0.85);
                htmlPages.push(`
                    <div class="page">
                        <div class="page-content" style="background-image: url('${imgData}'); background-size: contain; background-repeat: no-repeat; background-position: center; height:100%; background-color:white;"></div>
                    </div>
                `);
            }

            // 3. Add Blank Page if total inner pages are odd
            if (totalPages % 2 !== 0) {
                htmlPages.push(`
                    <div class="page">
                        <div class="page-content" style="background-color:#ffffff; height:100%;"></div>
                    </div>
                `);
            }

            // 4. Add Hard Back Cover
            htmlPages.push(`
                <div class="page hard" data-density="hard">
                    <div class="page-content" style="background-color:#f8fafc; height:100%;"></div>
                </div>
                <div class="page hard" data-density="hard">
                    <div class="page-content" style="background:#1e293b; display:flex; align-items:center; justify-content:center; color:white; height:100%;">
                        <h2 style="opacity:0.5;">THE END</h2>
                    </div>
                </div>
            `);

            bookContainer.innerHTML = htmlPages.join('');
            
            // Render first page to determine dimensions
            const firstPage = await pdfDoc.getPage(1);
            const firstViewport = firstPage.getViewport({ scale: 1 });
            const bookWidth = firstViewport.width;
            const bookHeight = firstViewport.height;

            initPageFlip(bookWidth, bookHeight);
            loading.style.display = 'none';
            
        } catch (error) {
            console.error('Error loading PDF:', error);
            loadingText.textContent = '지침서를 불러오는 데 실패했습니다.';
        }
    }

    function initPageFlip(pdfWidth, pdfHeight) {
        if (pageFlip) pageFlip.destroy();

        // Proportional scaling
        let finalWidth = Math.min(pdfWidth, 550);
        let finalHeight = Math.round((finalWidth / pdfWidth) * pdfHeight);

        pageFlip = new St.PageFlip(bookContainer, {
            width: finalWidth,
            height: finalHeight,
            size: "stretch",
            minWidth: 315,
            maxWidth: 1000,
            minHeight: 420,
            maxHeight: 1350,
            showCover: true,
            mobileScrollSupport: false,
            usePortrait: window.innerWidth < 800
        });

        pageFlip.loadFromHTML(bookContainer.querySelectorAll(".page"));

        pageFlip.on('flip', (e) => {
            updatePageInfo(e.data, pdfDoc.numPages);
        });

        if (prevBtn) prevBtn.onclick = () => pageFlip.flipPrev();
        if (nextBtn) nextBtn.onclick = () => pageFlip.flipNext();
        
        updatePageInfo(0, pdfDoc.numPages);
    }

    function updatePageInfo(currentPageIndex, totalPdfPages) {
        if (!pageInfo) return;
        let displayStr = "";
        
        // 0: Front Cover
        // 1: Inside Front Cover
        // 2 to (2 + totalPdfPages - 1): PDF contents
        
        if (currentPageIndex === 0) {
            displayStr = "표지";
        } else if (currentPageIndex >= 2 && currentPageIndex < 2 + totalPdfPages) {
            let pdfPageNum = currentPageIndex - 1;
            displayStr = `페이지 ${pdfPageNum} / ${totalPdfPages}`;
        } else {
            displayStr = "뒷표지 / 끝";
        }
        
        pageInfo.textContent = displayStr;
    }

    initLibrary();

    // Handle direct links from management.html
    const urlParams = new URLSearchParams(window.location.search);
    const initialPdf = urlParams.get('pdf');
    const initialName = urlParams.get('name');
    if (initialPdf) {
        const manual = manuals.find(m => m.pdf === initialPdf) || { pdf: initialPdf, name: initialName || '지침서' };
        openViewer(manual);
    }
});
