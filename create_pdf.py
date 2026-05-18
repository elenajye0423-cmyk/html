import sys
from PIL import Image

def create_pdf():
    image_path = r"C:\Users\elena\.gemini\antigravity\brain\700f1f47-9377-40e3-9208-f0569e303da4\batech_bifold_desk_topdown_1779067907045.png"
    pdf_path = r"c:\Users\elena\OneDrive\바탕 화면\5월6일\홈페이지자료\Batech_Web\batech_brochure.pdf"
    
    try:
        img = Image.open(image_path)
        # Convert to RGB to save as PDF
        if img.mode == 'RGBA':
            img = img.convert('RGB')
            
        img.save(pdf_path, "PDF", resolution=100.0)
        print("PDF created successfully at:", pdf_path)
    except Exception as e:
        print("Error creating PDF:", e)
        input("Press Enter to exit...")

if __name__ == "__main__":
    create_pdf()
