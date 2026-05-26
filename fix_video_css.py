import re

with open('video.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the bifold-spread CSS
old_css = r"""            .bifold-spread \{
                width: 100%; aspect-ratio: 1\.414 / 1;
                display: flex; background: #fff; border-radius: 6px;
                box-shadow: 0 20px 45px -10px rgba\(0,0,0,0\.25\);
                position: relative; overflow: hidden;
                transition: transform 0\.4s cubic-bezier\(0\.16,1,0\.3,1\), box-shadow 0\.4s ease;
                container-type: inline-size;
            \}"""

new_css = """            .bifold-spread {
                width: 100%; aspect-ratio: 1.414 / 1; min-height: max-content;
                display: flex; background: #fff; border-radius: 6px;
                box-shadow: 0 20px 45px -10px rgba(0,0,0,0.25);
                position: relative; overflow: hidden;
                transition: transform 0.4s cubic-bezier(0.16,1,0.3,1), box-shadow 0.4s ease;
                container-type: inline-size;
            }"""

content = re.sub(old_css, new_css, content)

with open('video.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated video.html")
