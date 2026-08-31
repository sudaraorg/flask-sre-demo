import random
import time

from flask import Flask, jsonify, request

app = Flask(__name__)

# In-memory "database"
items = [
    {"id": 1, "name": "keyboard"},
    {"id": 2, "name": "monitor"},
]


@app.route("/")
def health():
    return jsonify({"status": "ok"})


@app.route("/items", methods=["GET"])
def get_items():
    # Simulate variable latency so metrics/traces have something interesting to show
    time.sleep(random.uniform(0.05, 0.4))
    return jsonify(items)


@app.route("/items", methods=["POST"])
def add_item():
    data = request.get_json(force=True, silent=True) or {}
    name = data.get("name")
    if not name:
        return jsonify({"error": "name is required"}), 400

    new_item = {"id": len(items) + 1, "name": name}
    items.append(new_item)
    return jsonify(new_item), 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
