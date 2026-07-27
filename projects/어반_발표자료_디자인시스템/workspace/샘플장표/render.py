import sys, asyncio
from pathlib import Path
from playwright.async_api import async_playwright

async def main(src, out, theme):
    url = Path(src).resolve().as_uri() + f"?theme={theme}"
    async with async_playwright() as p:
        b = await p.chromium.launch(headless=True)
        c = await b.new_context(viewport={"width":1600,"height":900},
                                device_scale_factor=2,
                                color_scheme="light" if theme=="light" else "dark")
        pg = await c.new_page()
        await pg.goto(url, wait_until="networkidle")
        await pg.evaluate("document.fonts.ready")
        await pg.screenshot(path=out, type="png", full_page=False, animations="disabled")
        await b.close()

asyncio.run(main(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv)>3 else "dark"))
