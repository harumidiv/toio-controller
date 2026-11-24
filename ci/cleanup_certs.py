#!/usr/bin/env python3
"""
App Store Connect の証明書を一覧し、対象のものを失効（削除）するスクリプト。
GitHub Actions 上で、Secrets (ASC_KEY_ID / ASC_ISSUER_ID / ASC_KEY_CONTENT) を使って実行する。

環境変数:
  DELETE_MODE=true のときだけ実際に失効する。それ以外は一覧表示のみ。

対象の特定方法:
  API には作成日の項目がないため、有効期限で特定する。
  配布用証明書の有効期間は1年なので、2026-11-23/24 に作られた証明書は
  有効期限が 2027-11-23 / 2027-11-24（UTC）になっている。
"""

import base64
import json
import os
import subprocess
import sys
import tempfile
import time
import urllib.request
import urllib.error

API_BASE = "https://api.appstoreconnect.apple.com"
TARGET_EXPIRY_PREFIXES = ("2027-11-23", "2027-11-24")


def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def der_to_raw(der: bytes, size: int = 32) -> bytes:
    assert der[0] == 0x30, "DER SEQUENCE expected"
    idx = 2
    if der[1] & 0x80:
        idx = 2 + (der[1] & 0x7F)
    assert der[idx] == 0x02
    r_len = der[idx + 1]
    r = der[idx + 2: idx + 2 + r_len]
    idx2 = idx + 2 + r_len
    assert der[idx2] == 0x02
    s_len = der[idx2 + 1]
    s = der[idx2 + 2: idx2 + 2 + s_len]
    r = r.lstrip(b"\x00").rjust(size, b"\x00")[-size:]
    s = s.lstrip(b"\x00").rjust(size, b"\x00")[-size:]
    return r + s


def norm_serial(s: str) -> str:
    return format(int(str(s).replace(":", "").strip(), 16), "X")


def make_jwt(key_id: str, issuer_id: str, key_path: str) -> str:
    now = int(time.time())
    header = {"alg": "ES256", "kid": key_id, "typ": "JWT"}
    payload = {"iss": issuer_id, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}
    signing_input = (
        b64url(json.dumps(header, separators=(",", ":")).encode())
        + "."
        + b64url(json.dumps(payload, separators=(",", ":")).encode())
    )
    proc = subprocess.run(
        ["openssl", "dgst", "-sha256", "-sign", key_path],
        input=signing_input.encode(), capture_output=True,
    )
    if proc.returncode != 0:
        sys.exit("openssl signing failed: " + proc.stderr.decode(errors="replace"))
    return signing_input + "." + b64url(der_to_raw(proc.stdout))


def api(token: str, method: str, url: str):
    req = urllib.request.Request(
        url,
        method=method,
        headers={"Authorization": "Bearer " + token, "Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req) as resp:
            body = resp.read().decode()
            return resp.status, (json.loads(body) if body else {})
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode(errors="replace")


def main() -> None:
    key_id = os.environ["ASC_KEY_ID"]
    issuer_id = os.environ["ASC_ISSUER_ID"]
    key_b64 = os.environ["ASC_KEY_CONTENT"]
    delete_mode = os.environ.get("DELETE_MODE", "false") == "true"

    fd, key_path = tempfile.mkstemp(suffix=".p8")
    try:
        with os.fdopen(fd, "wb") as f:
            f.write(base64.b64decode(key_b64))
        os.chmod(key_path, 0o600)
        token = make_jwt(key_id, issuer_id, key_path)
    finally:
        if os.path.exists(key_path):
            os.remove(key_path)

    certs = []
    url = API_BASE + "/v1/certificates?limit=200"
    for _ in range(5):
        status, data = api(token, "GET", url)
        if status != 200:
            sys.exit(f"Failed to list certificates (HTTP {status}): {data}")
        certs.extend(data.get("data", []))
        url = (data.get("links") or {}).get("next")
        if not url:
            break

    serials_file = None
    if "--serials-file" in sys.argv:
        serials_file = sys.argv[sys.argv.index("--serials-file") + 1]
    wanted = set()
    if serials_file:
        with open(serials_file) as f:
            wanted = {norm_serial(line) for line in f if line.strip()}
        print(f"Serials-file mode: {serials_file} ({len(wanted)} serial(s))")

    print(f"Total certificates: {len(certs)}")
    targets = []
    for c in certs:
        a = c.get("attributes", {})
        expiry = a.get("expirationDate", "")
        if serials_file:
            hit = norm_serial(a.get("serialNumber", "0")) in wanted
        else:
            hit = expiry.startswith(TARGET_EXPIRY_PREFIXES)
        if hit:
            targets.append(c)
        print(
            f"- id={c.get('id')} name={a.get('name')} type={a.get('certificateType')} "
            f"serial={a.get('serialNumber')} expiry={expiry}"
            + ("  <-- TARGET" if hit else "")
        )

    if serials_file:
        print(f"\nTargets (serials recorded in this run): {len(targets)}")
    else:
        print(f"\nTargets (expiry {', '.join(TARGET_EXPIRY_PREFIXES)}): {len(targets)}")
        if not delete_mode:
            print("List-only mode. Nothing was deleted.")
            return
    if not targets:
        print("No targets to delete.")
        return

    for c in targets:
        status, body = api(token, "DELETE", f"{API_BASE}/v1/certificates/{c.get('id')}")
        a = c.get("attributes", {})
        if status == 204:
            print(f"Revoked: serial={a.get('serialNumber')} expiry={a.get('expirationDate')}")
        else:
            print(f"FAILED (HTTP {status}): serial={a.get('serialNumber')} -> {body}")


if __name__ == "__main__":
    main()
