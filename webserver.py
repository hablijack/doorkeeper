#!/usr/bin/env python
# # -*- coding: utf-8 -*-

from flask import Flask, render_template, Response, send_from_directory
from gevent.pywsgi import WSGIServer
import os

# App Globals (do not edit)
app = Flask(__name__)

@app.route('/index.html')
@app.route('/')
def index():
    known_faces = []
    for root, dirs, files in os.walk("./known_faces/"):
        for filename in files:
            known_faces.append(filename)
    return render_template('index.html', known_faces=known_faces, unknown_faces=[])

@app.route('/assets/<path:path>')
def send_js(path):
    return send_from_directory('templates/assets', path)

@app.route('/known_faces/<path:path>')
def send_known_faces(path):
    return send_from_directory('known_faces', path)

@app.route('/unknown_faces/<path:path>')
def send_unknown_faces(path):
    return send_from_directory('unknown_faces', path)

if __name__ == '__main__':
    http_server = WSGIServer(('', 5000), app)
    http_server.serve_forever()
