import markdown
import sys
import os
import re


def convert():
    # 1. 檢查是否有輸入參數
    if len(sys.argv) < 2:
        print("用法提示: py convert_md_to_html.py <你的檔名.md>")
        return

    input_file = sys.argv[1]

    # 2. 檢查檔案是否存在
    if not os.path.exists(input_file):
        print(f"錯誤：找不到檔案 '{input_file}'")
        return

    # 自動生成輸出檔名 (例如 table.md -> table.html)
    output_file = os.path.splitext(input_file)[0] + ".html"

    # 定義墨色 CSS 樣式
    css_styles = """
    <style>
        body { font-family: "Noto Serif TC", serif; line-height: 1.8; color: #2c3e50; margin: 40px auto; padding: 20px; background-color: #fdfaf5; }
        .content-box { background: white; padding: 40px; border: 1px solid #dcdcdc; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
        h2.question { color: #8b0000; border-bottom: none; margin-bottom: 0; padding-bottom: 5px; }
        h2.question::before { content: "●"; color: #8b0000; font-size: 0.6em; margin-right: 10px; vertical-align: middle; }
        h2.answer { color: #2f4f4f; border-bottom: 1px solid #eee; margin-top: 0; padding-top: 0; padding-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th { background-color: #f2f2f2; border-bottom: 2px solid #333; padding: 10px; text-align: left; }
        td { border-bottom: 1px solid #eee; padding: 10px; }
        strong { color: #b22222; }
    </style>
    """

    try:
        with open(input_file, "r", encoding="utf-8") as f:
            text = f.read()

        # 3. 轉換 Markdown
        # extensions=["extra", "codehilite"] 支援表格與代碼高亮
        html_body = markdown.markdown(text, extensions=["extra", "codehilite", "nl2br"])

        # 4. 組合完整 HTML
        full_html = f"""
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>{os.path.splitext(input_file)[0]}</title>
    {css_styles}
</head>
<body>
    <div class="content-box">
        {html_body}
    </div>
</body>
</html>
"""

        with open(output_file, "w", encoding="utf-8") as f:
            f.write(full_html)

        print(f"成功！已轉換：{input_file} -> {output_file}")

    except Exception as e:
        print(f"發生意外錯誤: {e}")


if __name__ == "__main__":
    convert()
