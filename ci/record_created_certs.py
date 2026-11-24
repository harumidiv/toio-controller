#!/usr/bin/env python3
"""
この実行で CI が作成した証明書（名前が "Created via API" のもの）の
シリアル番号をキーチェーンから読み取り、ファイルに書き出すスクリプト。
アップロード用ワークフローの後段（if: always()）で使い、
続く失効ステップが「この実行で作られた証明書だけ」を消せるようにする。

使い方: python3 ci/record_created_certs.py <出力ファイルパス>
何があっても終了コード 0 で終わる（クリーンアップ側を止めないため）。
"""

import os
import re
import subprocess
import sys
import tempfile


def main() -> int:
    out_path = sys.argv[1] if len(sys.argv) > 1 else "created_cert_serials.txt"
    serials = []
    try:
        proc = subprocess.run(
            ["security", "find-certificate", "-a", "-p"],
            capture_output=True, text=True, timeout=60,
        )
        pem = proc.stdout or ""
    except Exception as e:  # noqa: BLE001
        print(f"record_created_certs: security command failed: {e}")
        pem = ""

    blocks = re.findall(
        r"-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----", pem, re.S
    )
    print(f"record_created_certs: {len(blocks)} certificate(s) in keychain")
    for block in blocks:
        path = None
        try:
            with tempfile.NamedTemporaryFile("w", suffix=".pem", delete=False) as f:
                f.write(block)
                path = f.name
            r = subprocess.run(
                ["openssl", "x509", "-in", path, "-noout", "-subject", "-serial"],
                capture_output=True, text=True, timeout=30,
            )
            text = r.stdout
        except Exception as e:  # noqa: BLE001
            print(f"record_created_certs: openssl failed for one cert: {e}")
            continue
        finally:
            if path and os.path.exists(path):
                os.unlink(path)
        if "Created via API" not in text:
            continue
        m = re.search(r"serial=([0-9A-Fa-f:]+)", text)
        if m:
            serials.append(format(int(m.group(1).replace(":", ""), 16), "X"))

    with open(out_path, "w") as f:
        for s in serials:
            f.write(s + "\n")
    print(f"record_created_certs: recorded {len(serials)} created certificate(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
