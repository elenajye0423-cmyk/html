document.addEventListener('DOMContentLoaded', () => {
    const pdfUpload = document.getElementById('pdf-upload');
    const fileName = document.getElementById('file-name');
    const loading = document.getElementById('loading');
    const progress = document.getElementById('progress');
    const loadingText = document.getElementById('loading-text');
    const bookArea = document.getElementById('book-area');
    const bookContainer = document.getElementById('book');
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    const pageInfo = document.getElementById('page-info');

    let pageFlip = null;
    let pdfDoc = null;

    // Load PDF from URL if provided (for management viewer)
    const urlParams = new URLSearchParams(window.location.search);
    const pdfUrl = urlParams.get('pdf');

    if (pdfUrl) {
        loadPdf(pdfUrl);
    }

    if (pdfUpload) {
        pdfUpload.addEventListener('change', async (e) => {
            const file = e.target.files[0];
            if (file && file.type === 'application/pdf') {
                fileName.textContent = file.name;
                const fileUrl = URL.createObjectURL(file);
                loadPdf(fileUrl);
            }
        });
    }

    async function loadPdf(url) {
        if (loading) loading.style.display = 'block';
        if (bookArea) bookArea.style.display = 'none';
        if (bookContainer) bookContainer.innerHTML = '';
        
        try {
            const loadingTask = pdfjsLib.getDocument(url);
            pdfDoc = await loadingTask.promise;
            
            const totalPages = pdfDoc.numPages;
            loadingText.textContent = `Rendering ${totalPages} pages...`;
            
            for (let i = 1; i <= totalPages; i++) {
                const page = await pdfDoc.getPage(i);
                const viewport = page.getViewport({ scale: 1.5 });
                
                const canvas = document.createElement('canvas');
                const context = canvas.getContext('2d');
                canvas.height = viewport.height;
                canvas.width = viewport.width;
                
                await page.render({ canvasContext: context, viewport: viewport }).promise;
                
                const pageDiv = document.createElement('div');
                pageDiv.className = 'page';
                const img = document.createElement('img');
                img.src = canvas.toDataURL();
                img.style.width = '100%';
                img.style.height = '100%';
                img.style.objectFit = 'contain';
                pageDiv.appendChild(img);
                bookContainer.appendChild(pageDiv);
                
                if (progress) progress.style.width = `${(i / totalPages) * 100}%`;
            }
            
            initPageFlip();
            
            if (loading) loading.style.display = 'none';
            if (bookArea) bookArea.style.display = 'block';
            
        } catch (error) {
            console.error('Error loading PDF:', error);
            if (loadingText) loadingText.textContent = 'Error loading PDF. Please try again.';
        }
    }

    function initPageFlip() {
        if (pageFlip) {
            pageFlip.destroy();
        }

        pageFlip = new St.PageFlip(bookContainer, {
            width: 550, // base page width
            height: 733, // base page height
            size: "stretch",
            minWidth: 315,
            maxWidth: 1000,
            minHeight: 420,
            maxHeight: 1350,
            maxShadowOpacity: 0.5,
            showCover: true,
            mobileScrollSupport: false
        });

        pageFlip.loadFromHTML(document.querySelectorAll(".page"));

        pageFlip.on('flip', (e) => {
            pageInfo.textContent = `Page ${e.data + 1} of ${pdfDoc.numPages}`;
        });

        if (prevBtn) prevBtn.onclick = () => pageFlip.flipPrev();
        if (nextBtn) nextBtn.onclick = () => pageFlip.flipNext();
        
        pageInfo.textContent = `Page 1 of ${pdfDoc.numPages}`;
    }
});
