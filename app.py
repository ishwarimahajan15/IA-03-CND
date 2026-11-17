from flask import Flask, jsonify
import os, socket
app = Flask(__name__)
@app.get("/")
def home():
    return f'''<!doctype html><html><head><title>Jenkins CI/CD Demo</title>
    <style>body{{font:16px system-ui;background:#f3f6fb;color:#17243a;margin:8vh auto;max-width:760px;padding:24px}}
    section{{background:white;border:1px solid #dce5f0;border-radius:16px;padding:32px}}
    .ok{{color:#087443;font-weight:700}}</style></head><body><section>
    <p class="ok">● Application is running</p><h1>Jenkins CI/CD + Terraform Demo</h1>
    <p>This application was packaged as a Docker image and deployed by an automated Jenkins pipeline.</p>
    <p><b>Version:</b> {os.getenv("APP_VERSION","1.0.0")}</p>
    <p><b>Container:</b> {socket.gethostname()}</p><p>Health check: <a href="/health">/health</a></p>
    </section></body></html>'''
@app.get("/health")
def health():
    return jsonify(status="ok", service="jenkins-terraform-demo"), 200
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT","5000")))
