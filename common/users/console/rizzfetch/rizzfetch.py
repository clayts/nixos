from terminaltexteffects.effects.effect_expand import Expand
from terminaltexteffects.effects.effect_slide import Slide
import sys, time
import subprocess
import platform
from terminaltexteffects.utils.graphics import Color
from terminaltexteffects.utils.graphics import Gradient
from pathlib import Path
import random, colorsys

def merge_lines(s1: str, s2: str) -> str:
    l1 = s1.splitlines()
    l2 = s2.splitlines()
    return "\n".join(a + b for a, b in zip(l1, l2))

def merge_frames(list1: list[str], list2: list[str]) -> list[str]:
    if not list1 and not list2:
        return []
    max_len = max(len(list1), len(list2))
    a_extended = ["\n\n\n"] * (max_len - len(list1)) + list1
    b_extended = ["\n\n\n"] * (max_len - len(list2)) + list2
    return [merge_lines(a, b) for a, b in zip(a_extended, b_extended)]

def logo() -> str:
	return subprocess.run(["toilet", "-f" ,"future", subprocess.run(["hostname"], capture_output=True, text=True, check=True).stdout.rstrip("\n")], capture_output=True, text=True, check=True).stdout

def hardware_name() -> str:
    # Try dmi fields that together form a usable product string
    base = Path("/sys/class/dmi/id")
    try:
        vendor = (base / "sys_vendor").read_text().strip()
        product = (base / "product_name").read_text().strip()
        version = (base / "product_version").read_text().strip()
        parts = [p for p in (vendor, product, version) if p]
        return " ".join(parts) if parts else "Unknown"
    except Exception:
        return "Unknown"


def distro_name() -> str:
	release = platform.freedesktop_os_release()
	return release["PRETTY_NAME"] + " " + release["BUILD_ID"]

def kernel_name() -> str:
	return platform.system() + " " + platform.release()

def info() -> str:
	return " "+hardware_name() + "\n " + distro_name() + "\n " + kernel_name()


CSI = "\033["

def play_frames(lines: list[str]) -> None:
    iv = 1.0 / 160
    first = True
    for block in lines:
        t0 = time.perf_counter()
        if not first:
            _ = sys.stdout.write(f"{CSI}3A")
            _ = sys.stdout.write((f"{CSI}2K\n") * 3)
            _ = sys.stdout.write(f"{CSI}3A")
        first = False
        parts = block.splitlines()
        for i in range(3):
            print(parts[i] if i < len(parts) else "")
        _ = sys.stdout.flush()
        rem = iv - (time.perf_counter() - t0)
        if rem > 0:
            time.sleep(rem)


def rainbow(n: int) -> tuple[Color, ...]:
    base = random.random()
    s, v = 0.9, 0.95
    return tuple(
      	Color(f"{int(r*255):02x}{int(g*255):02x}{int(b*255):02x}")
        for r, g, b in (
            colorsys.hsv_to_rgb((base + i / n) % 1.0, s, v) for i in range(n)
        )
    )

logo_effect = Expand(logo())
logo_effect.terminal_config.frame_rate = 0
logo_effect.effect_config.movement_speed = 0.1
logo_effect.effect_config.final_gradient_stops = rainbow(5)
logo_effect.effect_config.final_gradient_direction = Gradient.Direction.DIAGONAL
logo_effect.effect_config.final_gradient_frames=10

info_effect = Slide(info())
info_effect.terminal_config.frame_rate = 0
info_effect.effect_config.movement_speed = 1.5
info_effect.effect_config.final_gradient_frames = 1
info_effect.effect_config.final_gradient_stops = (Color("666666"),Color("Ffffff"),)
info_effect.effect_config.final_gradient_direction = Gradient.Direction.VERTICAL
info_effect.effect_config.reverse_direction=True

play_frames(merge_frames([frame for frame in logo_effect],[frame for frame in info_effect]))
