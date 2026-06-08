import sys, os, json, struct, ctypes, ctypes.util, glob

# Zen の zen-sessions.jsonlz4 へ宣言した spaces / pins(essential)をマージする本体。
# 呼び出し: python3 <this> <入力 mozlz4> <出力 mozlz4>
# 宣言データは環境変数 ZEN_DECLARED_JSON(JSON 文字列)で受け取る。
#
# mozlz4 形式: "mozLz40\0"(8B) + uint32LE 非圧縮長 + LZ4 raw block。
# 解凍/再圧縮は liblz4 の LZ4_decompress_safe / LZ4_compress_default を ctypes で直接呼ぶ
# (lz4 CLI は frame 形式しか扱えず raw block を生成できないため)。


# ---- mozlz4 デコード(ctypes + liblz4 の LZ4_decompress_safe) ----
def lz4_decompress_block(data, out_len):
    out = ctypes.create_string_buffer(out_len)
    n = _lib.LZ4_decompress_safe(data, out, len(data), out_len)
    if n < 0:
        raise RuntimeError("LZ4_decompress_safe failed")
    return out.raw[:n]


def mozlz4_decompress(path):
    with open(path, "rb") as f:
        raw = f.read()
    assert raw[:8] == b"mozLz40\x00", raw[:8]
    out_len = struct.unpack("<I", raw[8:12])[0]
    return lz4_decompress_block(raw[12:], out_len)


# ---- mozlz4 エンコード(ctypes + liblz4 の LZ4_compress_default) ----
def find_liblz4():
    p = ctypes.util.find_library("lz4")
    if p:
        return p
    for g in ["/opt/homebrew/lib/liblz4.dylib", "/opt/homebrew/opt/lz4/lib/liblz4.dylib",
              "/usr/lib/liblz4.dylib", "/usr/local/lib/liblz4.dylib"]:
        for m in glob.glob(g):
            return m
    raise RuntimeError("liblz4 not found")


_lib = ctypes.CDLL(find_liblz4())
_lib.LZ4_compressBound.restype = ctypes.c_int
_lib.LZ4_compressBound.argtypes = [ctypes.c_int]
_lib.LZ4_compress_default.restype = ctypes.c_int
_lib.LZ4_compress_default.argtypes = [ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int, ctypes.c_int]
_lib.LZ4_decompress_safe.restype = ctypes.c_int
_lib.LZ4_decompress_safe.argtypes = [ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int, ctypes.c_int]


def mozlz4_compress(data):
    bound = _lib.LZ4_compressBound(len(data))
    dst = ctypes.create_string_buffer(bound)
    n = _lib.LZ4_compress_default(data, dst, len(data), bound)
    if n <= 0:
        raise RuntimeError("LZ4_compress_default failed")
    return b"mozLz40\x00" + struct.pack("<I", len(data)) + dst.raw[:n]


# ---- 宣言データ → セッション形式への変換 ----
def wrap(s):
    return s if s.startswith("{") else "{%s}" % s


def build_space(s):
    container = 0 if s.get("container") is None else s["container"]
    theme = s.get("theme", {}) or {}
    colors = theme.get("colors") or []
    grad = [{
        "algorithm": c["algorithm"],
        "c": [c["red"], c["green"], c["blue"]],
        "isCustom": c["custom"],
        "isPrimary": c["primary"],
        "lightness": c["lightness"],
        "position": {"x": c["x"], "y": c["y"]},
        "type": c["type"],
    } for c in colors]
    return {
        "containerTabId": container,
        "icon": s["icon"],
        "name": s["name"],
        "position": s["position"],
        "theme": {
            "type": theme.get("type") or "gradient",
            "gradientColors": grad,
            "opacity": 0.5 if theme.get("opacity") is None else theme["opacity"],
            "texture": 0 if theme.get("texture") is None else theme["texture"],
            "rotation": theme.get("rotation"),
        },
        "uuid": wrap(s["id"]),
        "hasCollapsedPinnedTabs": False,
    }


def build_pin(p):
    # 既存タブが無い場合に追加する新規 essential タブの最小構成。
    tab = {
        "pinned": True,
        "hidden": False,
        "zenWorkspace": None if p.get("workspace") is None else wrap(p["workspace"]),
        "zenSyncId": wrap(p["id"]),
        "zenEssential": bool(p.get("isEssential")),
        "zenDefaultUserContextId": "true",
        "zenPinnedIcon": None,
        "zenIsEmpty": False,
        "zenHasStaticIcon": False,
        "zenGlanceId": None,
        "zenIsGlance": False,
        "searchMode": None,
        "userContextId": 0 if p.get("container") is None else p["container"],
        "attributes": {},
        "index": p["position"],
        "lastAccessed": 0,
        "groupId": None,
    }
    if p.get("title"):
        tab["zenStaticLabel"] = p["title"]
    tab["entries"] = [{
        "url": p["url"],
        "title": p.get("title"),
        "charset": "UTF-8",
        "ID": 0,
        "persist": True,
    }]
    return tab


# ---- マージ ----
def merge(session, declared):
    decl_spaces = [build_space(s) for s in declared.get("spaces", [])]
    decl_pins = [build_pin(p) for p in declared.get("pins", [])]

    session.setdefault("spaces", [])
    session.setdefault("tabs", [])
    session.setdefault("folders", [])
    session.setdefault("groups", [])
    session.setdefault("splitViewData", [])

    # spaces: uuid 一致で既存へ宣言を上書きマージ、無ければ追加。
    by_uuid = {s["uuid"]: s for s in decl_spaces}
    existing_uuids = {s.get("uuid") for s in session["spaces"]}
    for s in session["spaces"]:
        o = by_uuid.get(s.get("uuid"))
        if o is not None:
            s.update(o)
    for s in decl_spaces:
        if s["uuid"] not in existing_uuids:
            session["spaces"].append(s)

    # pins: zenSyncId 一致で対象タブの該当フィールドのみ上書き、無ければ追加。
    by_syncid = {t["zenSyncId"]: t for t in decl_pins}
    existing_syncids = {t.get("zenSyncId") for t in session["tabs"]}
    overwrite_keys = ["pinned", "zenEssential", "zenWorkspace", "userContextId", "index", "entries"]
    for t in session["tabs"]:
        o = by_syncid.get(t.get("zenSyncId"))
        if o is not None:
            for k in overwrite_keys:
                t[k] = o[k]
            # zenStaticLabel は宣言にある場合のみ反映。
            if "zenStaticLabel" in o:
                t["zenStaticLabel"] = o["zenStaticLabel"]
            # groupId はマージ対象だが宣言 pin は常に None。既存の所属を尊重し触れない。
    for t in decl_pins:
        if t["zenSyncId"] not in existing_syncids:
            session["tabs"].append(t)

    # 既定挙動: タブ・folders・groups を index 昇順で安定ソート。
    session["tabs"].sort(key=lambda t: t.get("index", 0))
    session["folders"].sort(key=lambda f: f.get("index", 0))
    session["groups"].sort(key=lambda g: g.get("index", 0))
    return session


def main():
    in_path, out_path = sys.argv[1], sys.argv[2]
    declared = json.loads(os.environ["ZEN_DECLARED_JSON"])
    raw = mozlz4_decompress(in_path)
    session = json.loads(raw.decode("utf-8"))
    merged = merge(session, declared)
    out = json.dumps(merged, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    blob = mozlz4_compress(out)
    # ラウンドトリップ検証: 書き出す前に自前デコーダで復号して JSON 妥当性を確認。
    check_len = struct.unpack("<I", blob[8:12])[0]
    rt = lz4_decompress_block(blob[12:], check_len)
    json.loads(rt.decode("utf-8"))
    tmp = out_path + ".tmp.%d" % os.getpid()
    with open(tmp, "wb") as f:
        f.write(blob)
    os.replace(tmp, out_path)


main()
